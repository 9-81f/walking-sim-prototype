extends RigidBody3D
class_name WorldPickup

@export var display_standing := false
@export var data: ItemData
@export_range(1, 99) var _quantity := 1
@export var _focus_material_overlay: StandardMaterial3D
@onready var _mesh_socket: MeshInstance3D = $MeshSocket
@onready var interactable: Interactable3D = $Interactable3D

func set_item_data(item_data: ItemData) -> void:
	data = item_data
	
func set_pickup_quantity(amount: int) -> void:
	_quantity = amount

func _ready() -> void:
	if display_standing:
		_mesh_socket.rotation.x = 0.0
	else:
		_mesh_socket.rotation.x = 80.0
		
	if data and data.mesh:
		_mesh_socket.mesh = data.mesh
	
	if interactable:
		interactable.focused.connect(_on_focused)
		interactable.interacted.connect(_on_interacted)
		interactable.blurred.connect(_on_blurred)
		
func _on_focused(_interactor: Node3D) -> void:
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

func _on_blurred(_interactor: Node3D) -> void:
	_mesh_socket.material_overlay = null
	
func _store_pickup(callback: Callable = func(): pass) -> void:
	var leftover := InventoryDataManager.store(data, _quantity)
	
	if leftover == _quantity: 
		return
	
	if callback: callback.call()
		
	if leftover > 0: 
		_quantity = leftover
		return
		
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
