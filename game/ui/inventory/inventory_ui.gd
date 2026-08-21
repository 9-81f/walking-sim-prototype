extends UIWindow
class_name InventoryUI

@export var _item_slot_scene: PackedScene
@export var _item_slot_grid_container: GridContainer
@export var _info_name: Label
@export var _info_description: Label

var equip: EquipComponent = null
var _focused_item: ItemData = null

func _ready() -> void:
	super._ready()
	InventoryDataManager.updated.connect(refresh)

func _on_refresh() -> void:
	for child in _item_slot_grid_container.get_children():
		_item_slot_grid_container.remove_child(child)
		child.queue_free()
		
	_focused_item = null
	_info_name.text = ""
	_info_description.text = ""
	
	var first_slot: ItemSlot = null
		
	for item: ItemData in InventoryDataManager.list:
		var item_slot: ItemSlot = _item_slot_scene.instantiate()
		_item_slot_grid_container.add_child(item_slot)
		
		if not first_slot: first_slot = item_slot
		
		var quantity := InventoryDataManager.list[item]
		var is_holding := equip.is_holding(item) if equip else false
		item_slot.setup(item, quantity, is_holding)
		
		item_slot.focus_entered.connect(func():
			_focused_item = item
			_info_name.text = item.display_name
			_info_description.text = item.description
		)
		
		item_slot.focus_exited.connect(func():
			if _focused_item == item:
				_focused_item = null
				_info_name.text = ""
				_info_description.text = ""
		)
	
	if first_slot:
		first_slot.grab_focus()
	
func _get_initial_focus() -> Control:
	if _item_slot_grid_container.get_child_count() > 0:
		return _item_slot_grid_container.get_child(0)
	return null
	
# ==========================================
# INPUT LIFECYCLE
# ==========================================

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		toggle()
		get_viewport().set_input_as_handled()
		
	if not visible: return
	
	if event.is_action_pressed("inventory_drop"):
		# NOTE: qty in this event can accept drop counter ui value in the future
		UiEvents.item_drop_requested.emit(_focused_item, 1)
