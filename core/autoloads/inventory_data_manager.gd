extends Node

signal updated()

const _world_pickup_scene: PackedScene = preload("res://game/interactables/pickup/base/world_pickup.tscn")
var list: Dictionary[ItemData, int] = {}
var _max_capacity := 8

# ===========================================
# The Golden Formula for Storing:
# var space: int = max_stack - current_qty
# var to_add: int = mini(incoming_qty, space)
# var leftover: int = incoming_qty - to_add
# ===========================================

func is_capacity_full() -> bool:
	return list.size() == _max_capacity
	
func is_empty() -> bool:
	return list.is_empty();
	
func is_item_stacked(item: ItemData) -> bool:
	if not has_item(item): 
		return false
	if not item.is_stackable and list[item] >= 1: 
		return true
	if item.is_stackable and list[item] >= item.max_stack_size: 
		return true
	return false
	
func has_item(item: ItemData) -> bool:
	return list.has(item)

func store(item: ItemData, qty: int = 1) -> int:
	if is_capacity_full():
		UiEvents.toast_requested.emit("Inventory is full!", null)
		return qty
		
	if is_item_stacked(item):
		UiEvents.toast_requested.emit("Maxed %s stack size limit of %d!" % [item.display_name, item.max_stack_size], item.icon)
		return qty
	
	if not item.is_stackable:
		list[item] = 1
		UiEvents.toast_requested.emit("Stored %dx %s to inventory." % [1, item.display_name], item.icon)
		updated.emit()
		return qty - 1
	
	var current_qty: int = list.get(item, 0);
	var available_space: int = item.max_stack_size - current_qty
	
	var add_amount := mini(qty, available_space)
	var leftover: int = qty - add_amount
	
	if add_amount > 0:
		list[item] = current_qty + add_amount
		var item_name := get_pluralized_item_name(item, add_amount)
		UiEvents.toast_requested.emit("Stored %dx %s to inventory." % [add_amount, item_name], item.icon)
		updated.emit()
	
	return leftover
	
func remove(item: ItemData, qty: int = 1) -> int:
	if is_empty():
		UiEvents.toast_requested.emit("Inventory is empty.", null)
		return 0
		
	if not list.has(item):
		return 0
		
	var available_qty: int = list[item]
	var amount_to_remove: int = mini(qty, available_qty)
	
	list[item] -= amount_to_remove
	
	if list[item] <= 0:
		list.erase(item)
	
	updated.emit()
		
	return amount_to_remove	
	
func spawn_drop(item: ItemData, world_drop_position: Vector3) -> void:
	if _world_pickup_scene:
		var world_pickup: WorldPickup = _world_pickup_scene.instantiate()
		world_pickup.set_item_data(item)
		get_tree().current_scene.add_child(world_pickup)
		world_pickup.global_position = world_drop_position

func get_pluralized_item_name(item: ItemData, pluralizer: int) -> String:
	if pluralizer > 1:
		return item.display_name + "s"
	else:
		return item.display_name
