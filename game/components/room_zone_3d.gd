extends Area3D
class_name RoomZone3D

@export var _room_objects: Array[Node3D] = []

var _room_interactables: Array[Interactable3D] = []

func _ready() -> void:
	collision_layer = 11
	set_collision_mask_value(3, true)
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	_collect_interactables()
	
	_set_room_interactables_active(false)

func _collect_interactables() -> void:
	_room_interactables.clear()
	for obj in _room_objects:
		if is_instance_valid(obj):
			_find_interactables_recursive(obj)

func _find_interactables_recursive(node: Node) -> void:
	if node is Interactable3D:
		_room_interactables.append(node)
		
	for child in node.get_children():
		_find_interactables_recursive(child)

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		_set_room_interactables_active(true)
		
func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		_set_room_interactables_active(false)
			
func _set_room_interactables_active(active: bool) -> void:
	for interactable in _room_interactables:
		if is_instance_valid(interactable):
			interactable.set_room_active(active)
