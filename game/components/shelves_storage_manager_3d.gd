extends Node3D
class_name ShelvesStorageManager3D

@export var _shelves: Dictionary[ShelfStorageComponent3D, ItemDataArray]
@export var _enclosure_toggles: Dictionary[SwitchToggleComponent, ItemDataArray]

func _ready() -> void:
	if not _shelves.is_empty():
		for shelf: ShelfStorageComponent3D in _shelves.keys():
			var items := _shelves[shelf]
			
			if not items: continue
			
			if not items.list.is_empty():
				shelf.populate_storage(items.list)
	
	if not _enclosure_toggles.is_empty():
		for toggle: SwitchToggleComponent in _enclosure_toggles.keys():
			var keys := _enclosure_toggles[toggle]
			
			if not keys: continue
			
			var lock := toggle.lock
			
			if lock:
				if keys.list.is_empty(): return
				lock.required_keys = keys.list
