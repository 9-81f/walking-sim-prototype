extends Node3D
class_name LootContainerComponent

@export var _enclosures: Dictionary[InteractableEnclosure3D, LootData] = {}

var _world_pickup_scene: PackedScene = preload("res://game/interactables/pickup/base/world_pickup.tscn")

var _managed_interactables: Dictionary[InteractableEnclosure3D, Array] = {}

func _ready() -> void:
	for enclosure: InteractableEnclosure3D in _enclosures.keys():
		var loot := _enclosures[enclosure]
		
		_managed_interactables[enclosure] = []
			
		if loot and loot.list:
			for item: ItemData in loot.list:
				_spawn_pickup(enclosure, item)
			
		if loot and not loot.accepted_keys.is_empty() and enclosure.lock:
			enclosure.lock.required_keys = loot.accepted_keys
		
		enclosure.opened.connect(func(): _set_loot_interaction_active(enclosure, true))
		enclosure.closed.connect(func(): _set_loot_interaction_active(enclosure, false))
			
		_set_loot_interaction_active(enclosure, enclosure.is_opened)
		
func _spawn_pickup(enclosure: InteractableEnclosure3D,item: ItemData) -> void:
	var world_pickup := _world_pickup_scene.instantiate() as WorldPickup
	world_pickup.set_item_data(item)
	enclosure.add_child(world_pickup)
	world_pickup.global_position = enclosure.global_position
	
	var interactables_list: Array = _managed_interactables[enclosure]
	
	if world_pickup.interactable:
		var target_interactable := world_pickup.interactable
		interactables_list.append(target_interactable)
		
		world_pickup.tree_exited.connect(func():
			interactables_list.erase(target_interactable)
		)
	
		
func _set_loot_interaction_active(enclosure: InteractableEnclosure3D, active: bool) -> void:
		if not _managed_interactables.has(enclosure): return
		
		var list: Array = _managed_interactables[enclosure]
		
		if list.size() > 0:
			for item in list:
				var interactable := item as Interactable3D
				
				if is_instance_valid(item):
					interactable.is_enabled = active
					interactable.update_prompt_state()
