extends RigidBody3D
class_name WorldPickup

@export_category("Display Settings")
@export var display_standing := false
@export var _enable_focus_overlay := true
@export var _focus_material_overlay: StandardMaterial3D
@export var _interaction_radius := 0.3:
	set(value):
		_interaction_radius = value
		_update_interaction_radius()
		
@export var _body_radius := 0.1:
	set(value):
		_body_radius = value
		_update_body_radius()

@export_category("Data Settings")
@export var data: ItemData
@export_range(1, 99) var _quantity := 1

@export_category("Audio Settings")
@export var _default_stream: AudioStream = preload("res://assets/sfx/rpg-audio/handleSmallLeather.ogg")

@onready var _mesh_socket: MeshInstance3D = $MeshSocket
@onready var interactable: Interactable3D = $Interactable3D
@onready var _body_shape: CollisionShape3D = $CollisionShape3D
@onready var _interact_shape: CollisionShape3D = $Interactable3D/CollisionShape3D
@onready var _audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

func set_item_data(item_data: ItemData) -> void:
	data = item_data
	
func set_pickup_quantity(amount: int) -> void:
	_quantity = amount

func _ready() -> void:
	_audio_player.stream = _default_stream
	_audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	
	if display_standing:
		_mesh_socket.rotation.x = 0.0
	else:
		_mesh_socket.rotation.x = -90.0
		
	_normalize_mesh_pivot()
	
	if interactable:
		if _interact_shape:
			_update_interaction_radius()
		
		if _body_shape:
			_update_body_radius()
			
		match data.type:
			ItemData.ItemType.INSPECTABLE:
				interactable.prompt_message = "Inspect"
			ItemData.ItemType.CARRYABLE:
				interactable.prompt_message = "Carry"
			
		interactable.focused.connect(_on_focused)
		interactable.interacted.connect(_on_interacted)
		interactable.blurred.connect(_on_blurred)
		
func _update_interaction_radius() -> void:
	if not is_node_ready() or not _interact_shape: return
	
	if not _interact_shape.shape is SphereShape3D:
		_interact_shape.shape = SphereShape3D.new()
	else:
		_interact_shape.shape = _interact_shape.shape.duplicate()
		
	(_interact_shape.shape as SphereShape3D).radius = _interaction_radius
		
func _update_body_radius() -> void:
	if not is_node_ready() or not _body_shape: return
	
	if not _body_shape.shape is CylinderShape3D:
		_body_shape.shape = CylinderShape3D.new()
	else:
		_body_shape.shape = _body_shape.shape.duplicate()
		
	(_body_shape.shape as CylinderShape3D).radius = _body_radius

func _on_focused(_interactor: Node3D) -> void:
	if not _enable_focus_overlay: return
	_mesh_socket.material_overlay = _focus_material_overlay

func _on_interacted(interactor: Node3D) -> void:	
	if data.is_storable: 
		_store_pickup(
			func():
				_interactor_response(interactor)
		)
	else:
		match data.type:
			ItemData.ItemType.INSPECTABLE:
				_inspect_pickup()
			ItemData.ItemType.CARRYABLE:
				_carry_pickup(interactor)
				
	_audio_player.play()

func _on_blurred(_interactor: Node3D) -> void:
	if not _enable_focus_overlay: return
	_mesh_socket.material_overlay = null
	
func _store_pickup(callback: Callable = func(): pass) -> void:
	var leftover := InventoryDataManager.store(data, _quantity)
	
	if leftover == _quantity: 
		return
	
	if callback: callback.call()
		
	if leftover > 0: 
		_quantity = leftover
		return
	
	hide()
		
	await _audio_player.finished
		
	queue_free()
	
func _inspect_pickup(callback: Callable = func(): pass) -> void:
	if callback: callback.call()
	UiEvents.item_inspection_requested.emit(data)
	
func _carry_pickup(interactor: Node3D) -> void:
	var carry_comp := interactor.get_node_or_null("CarryComponent") as CarryComponent
	if carry_comp:
		carry_comp.set_to_socket(self)
	
func _interactor_response(interactor: Node3D) -> void:
	var anim_comp := interactor.get_node_or_null("AnimationComponent") as AnimationComponent
	if anim_comp:
		anim_comp.set_action_one_shot("grab")
		
func _normalize_mesh_pivot() -> void:
	if not data and not data.mesh: return
	
	_mesh_socket.mesh = data.mesh
	
	var aabb: AABB = data.mesh.get_aabb()
	
	_mesh_socket.position.y = -aabb.position.y
	
