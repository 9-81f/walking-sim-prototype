extends Node3D
class_name ShelfStorageComponent3D

@export var enclosure_toggle: SwitchToggleComponent

var _spawn_markers: Array[Marker3D] = []
var _world_pickup_scene: PackedScene = preload("res://game/interactables/pickup/world_pickup.tscn")

var managed_interactables: Array[Interactable3D] = []

func _ready() -> void:
	if get_child_count() > 0:
		for child in get_children():
			if child is Marker3D:
				_spawn_markers.append(child)
	
	if enclosure_toggle:
		enclosure_toggle.switch_toggled.connect(_on_enclosure_toggled)
				
func populate_storage(item_datas: Array[ItemData]) -> void:
	if item_datas.is_empty() or _spawn_markers.is_empty(): return
	
	if item_datas.size() > _spawn_markers.size():
		push_warning("[ShelfStorageComponent]: Item data count (%d) exceeds markers (%d). Leftover items skipped." % [item_datas.size(), _spawn_markers.size()])
	
	var spawn_count := min(item_datas.size(), _spawn_markers.size()) as int
	
	for i in range(spawn_count):
		var spawn_marker := _spawn_markers[i]
		var item_data := item_datas[i]
		
		if not item_data: continue
		
		var world_pickup := _world_pickup_scene.instantiate() as WorldPickup
		
		if is_instance_valid(world_pickup):
			world_pickup.display_standing = true
			
			world_pickup.set_item_data(item_data)
			
			add_child(world_pickup)
			
			if world_pickup.interactable:
				var target_interactable := world_pickup.interactable
				
				managed_interactables.append(target_interactable)
		
				world_pickup.tree_exited.connect(
					func(): managed_interactables.erase(target_interactable)
				)
			
			world_pickup.global_transform = spawn_marker.global_transform
	
	var is_open := enclosure_toggle.is_toggled if enclosure_toggle else true
	_on_enclosure_toggled(is_open)
			
func _on_enclosure_toggled(toggled: bool) -> void:
	for interactable in managed_interactables:
		if is_instance_valid(interactable):
			interactable.is_enabled = toggled
			interactable.update_prompt_state()
		
