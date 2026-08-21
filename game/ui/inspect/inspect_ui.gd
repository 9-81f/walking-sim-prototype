extends UIWindow
class_name InspectUI

#TODO: Complete inspect ui implementation
@onready var _mesh: MeshInstance3D = $PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/SubViewportContainer/SubViewport/MeshInstance3D
@onready var _subviewport_container: SubViewportContainer = $PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/SubViewportContainer
@onready var _subviewport_cam: Camera3D = $PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/SubViewportContainer/SubViewport/Camera3D
@onready var _item_name: Label = $PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/ItemName
@onready var _item_desc: Label = $PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/ItemDescription
@onready var _rich_texts: RichTextLabel = $PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/RichTextLabel

@export var _camera_zoom_speed := 2.0
@export var _inspect_x_rotation_speed := 10.0
@export var _inspect_y_rotation_speed := 10.0

var _current_item: ItemData
var _defaults: Dictionary[String, Variant]

func _ready() -> void:
	super._ready()
	
	_defaults = {
		"camera_pos": _subviewport_cam.position,
		"mesh_rotation": _mesh.rotation
	}
	
	UiEvents.item_inspection_requested.connect(_on_item_inspection_requested)
	
func _on_item_inspection_requested(item: ItemData) -> void:
	_setup(item)
	open()
	
func _on_refresh() -> void:
	if not _current_item: return
	
	_mesh.mesh = _current_item.mesh
	_item_name.text = _current_item.display_name
	_item_desc.text = _current_item.description
	if _current_item.readable_text:
		_rich_texts.text = _current_item.readable_text
	else:
		_rich_texts.text = ""
	
func _get_initial_focus() -> Control:
	return _subviewport_container
	
func _setup(item: ItemData) -> void:
	_current_item = item

func _physics_process(delta: float) -> void:
	if not visible: return
	
	var input_zoom := Input.get_axis("lean_left", "lean_right")
	var input_x_axis := Input.get_axis("move_left", "move_right")
	var input_y_axis := Input.get_axis("move_up", "move_down")
	
	var applied_zoom := (input_zoom * _camera_zoom_speed) * delta
	
	_subviewport_cam.position.z += applied_zoom
	_subviewport_cam.position.z = clampf(_subviewport_cam.position.z, 0.25, 1.0)
	
	_mesh.rotation.x += (input_y_axis * _inspect_x_rotation_speed) * delta
	_mesh.rotation.y += (input_x_axis * _inspect_y_rotation_speed) * delta
	
func close() -> void:
	super.close()
	if _defaults:
		_subviewport_cam.position = _defaults["camera_pos"]
		_mesh.rotation = _defaults["mesh_rotation"]

# ==========================================
# INPUT LIFECYCLE
# ==========================================

func _unhandled_input(event: InputEvent) -> void:
	if not visible: return
	
	if event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()
	
