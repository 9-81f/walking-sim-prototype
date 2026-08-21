extends Node
class_name ContainerComponent

@export var _door_component: InteractableDoorComponent
@export var _contained_interactables: Array[Node3D] = []

func _ready() -> void:
	if _door_component.is_opened:
		_set_items_enabled(true)
	else:
		_set_items_enabled(false)
		
	_door_component.door_opened.connect(func(): _set_items_enabled(true))
	_door_component.door_closed.connect(func(): _set_items_enabled(false))

func _set_items_enabled(enable: bool) -> void:
	for interactable in _contained_interactables:
		if is_instance_valid(interactable):
			var interactable_node := interactable.get_node_or_null("Interactable3D") as Interactable3D
			if interactable_node:
				interactable_node.is_enabled = enable
