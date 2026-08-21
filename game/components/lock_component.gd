extends Node
class_name LockComponent

@export_category("Lock Settings")
@export var _is_unlocked := false
@export var _is_permanent_locked := false
@export var _required_keys:Array[ItemData] = []
@export var _remove_key_on_use := false

func attempt_unlock() -> bool:
	if _is_permanent_locked: 
		UiEvents.toast_requested.emit("Door is locked from the other side.", null)
		return false
	
	if _is_unlocked: return true
	
	if _required_keys.is_empty():
		_is_unlocked = true
		return true
	
	var inventory_list := InventoryDataManager.list
	var missing_keys: Array[ItemData] = _required_keys.duplicate()
	var keys_to_inventory_remove: Array[ItemData] = []
	
	for item: ItemData in inventory_list:
		if item.type == ItemData.ItemType.KEY and missing_keys.has(item):
			missing_keys.erase(item)
			
			if _remove_key_on_use:
				keys_to_inventory_remove.append(item)
	
	if missing_keys.is_empty():
		_is_unlocked = true
		
		if _remove_key_on_use:
			for key: ItemData in keys_to_inventory_remove:
				UiEvents.toast_requested.emit("Used %s." % key.display_name, key.icon)
				InventoryDataManager.remove(key, 1)
	
		UiEvents.toast_requested.emit("Door unlocked.", null)
	else:
		var key_names: Array[String] = []
		
		for key: ItemData in missing_keys:
			key_names.append(key.display_name)
		
		_is_unlocked = false
		
		UiEvents.toast_requested.emit(
			"Door is locked. %s required." % [", ".join(PackedStringArray(key_names))], 
			null
		)
		
	return _is_unlocked

func animate_lock_jitter(door: MeshInstance3D, duration: float = 0.08) -> void:
	if not door: return
	
	var init_y := door.rotation_degrees.y
	
	var tween:= door.create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(door, "rotation_degrees:y", init_y + 1.5, duration)
	tween.tween_property(door, "rotation_degrees:y", init_y - 1.5, duration)
	tween.tween_property(door, "rotation_degrees:y", init_y, duration)
	
	
