extends Button
class_name ItemSlot

var item_data: ItemData
var is_equippable := false

func setup(data: ItemData, current_quantity: int, is_currently_equipped: bool) -> void:
	item_data = data
	icon = data.icon
	
	if data.type == ItemData.ItemType.EQUIPPABLE:
		is_equippable = true
		toggle_mode = true
		_update_equip_visual(is_currently_equipped)
	else:
		is_equippable = false
		toggle_mode = false
		text = str(current_quantity)
	
func _ready() -> void:
	pressed.connect(_on_pressed)
	GameEvents.item_equipped.connect(_on_global_item_equipped)
	GameEvents.item_unequip.connect(_on_global_item_unequipped)
	
func _on_pressed() -> void:
	if not item_data: return
	
	if is_equippable:
		if button_pressed:
			_update_equip_visual(true)
			UiEvents.item_use_requested.emit(item_data, 1)
		else:
			_update_equip_visual(false)
			UiEvents.item_stow_requested.emit(item_data, 1)
	else:
		UiEvents.item_use_requested.emit(item_data, 1)

func _on_global_item_equipped(equipped_item: ItemData) -> void:
	if not is_equippable: return
	
	if equipped_item == item_data:
		_update_equip_visual(true)
	elif equipped_item.hand_slot == item_data.hand_slot:
		_update_equip_visual(false)
		
func _on_global_item_unequipped(unequipped_item: ItemData) -> void:
	if is_equippable and unequipped_item == item_data:
		_update_equip_visual(false)
		
func _update_equip_visual(equipped: bool) -> void:
	set_pressed_no_signal(equipped)
	text = "E" if equipped else "U"
	
