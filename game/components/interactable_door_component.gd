extends Node3D
class_name InteractableDoorComponent

signal door_opened
signal door_closed

@export_category("Door Visuals")
@export var _door_pivot: MeshInstance3D
@export var _focus_material_overlay: StandardMaterial3D = preload("res://assets/materials/color_focus_overlay_02.tres")
@export_range(-180.0, 180.0, 0.15) var _default_pivot_angle := 0.0
@export_range(-180.0, 180.0, 0.15) var _opened_pivot_angle := 90.0
@export var _tween_duration := 0.5

@export_category("Door Dependencies Settings")
@export var _interact: Interactable3D

@export var _lock_component: LockComponent

@export var is_opened := false

func _ready() -> void:
	if _interact:
		_interact.focused.connect(_on_focused)
		_interact.interacted.connect(_on_interacted)
		_interact.blurred.connect(_on_blurred)
	
	if is_opened:
		_door_pivot.rotation_degrees.y = _opened_pivot_angle
		door_opened.emit()
	else:
		_door_pivot.rotation_degrees.y = _default_pivot_angle
		door_closed.emit()
		
func _on_focused(_interactor: Node3D) -> void:
	if _door_pivot and _focus_material_overlay:
		_door_pivot.material_overlay = _focus_material_overlay
		
func _on_interacted(_interactor: Node3D) -> void:
	if _lock_component:
		if not _lock_component.attempt_unlock(): 
			_lock_component.animate_lock_jitter(_door_pivot)
			return
	
	_remove_overlay()
	
	if is_opened:
		close()
	else:
		open()
		
func _on_blurred(_interactor: Node3D) -> void :
	_remove_overlay()
		
func open() -> void:
	if is_opened: return
	is_opened = true
	_interact.prompt_message = "Close"
	_animate_pivot(_opened_pivot_angle, Tween.EASE_IN_OUT)
	door_opened.emit()

func close() -> void:
	if not is_opened: return
	_interact.prompt_message = "Open"
	_animate_pivot(_default_pivot_angle, Tween.EASE_IN_OUT)
	is_opened = false
	door_closed.emit()
	
func _remove_overlay() -> void:
	if _door_pivot:
		_door_pivot.material_overlay = null
	
func _animate_pivot(target_angle: float, ease_type: Tween.EaseType) -> void:
	_interact.is_enabled = false
	
	var tween := _door_pivot.create_tween();
	tween.set_ease(ease_type).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(_door_pivot, "rotation_degrees:y", target_angle, _tween_duration)
	
	await tween.finished
	
	_interact.is_enabled = true
