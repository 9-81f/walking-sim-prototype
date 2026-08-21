extends Node
class_name EquipComponent

signal item_equip_started(item: ItemData)
signal item_equip_finished(item: ItemData)
signal item_unequip_started(item: ItemData)
signal item_unequip_finished(item: ItemData)

@export var r_hand_socket_marker: Marker3D
@export var l_hand_socket_marker: Marker3D
# NOTE: Can add more body parts equipment spawn points in the future

var pending_equip: ItemData
var pending_unequip: ItemData

var current_l_hand_equip: Equippable3D
var active_l_hand_item_data: ItemData

var current_r_hand_equip: Equippable3D
var active_r_hand_item_data: ItemData

var active_2_hands_item_data: ItemData

var _is_input_disabled := false

func is_equipping() -> bool:
	return current_r_hand_equip or current_l_hand_equip

func is_holding(item: ItemData) -> bool:
	var current_active_items := [
		active_l_hand_item_data,
		active_r_hand_item_data,
		active_2_hands_item_data
	]
	return current_active_items.has(item)

func request_equip(item: ItemData) -> void:
	pending_equip = item
	item_equip_started.emit(item)
	
func request_unequip(item: ItemData) -> void:
	pending_unequip = item
	item_unequip_started.emit(item)
	
func attach_pending_equip() -> void:
	if not pending_equip or not pending_equip.equip_scene:
		return
	
	var current_active_item_data: ItemData
	match pending_equip.hand_slot:
		ItemData.HandSlot.RIGHT_HAND:
			_equip_to_slot(pending_equip, r_hand_socket_marker, current_r_hand_equip, func(equippable: Equippable3D): current_r_hand_equip = equippable)
			active_r_hand_item_data = pending_equip
			current_active_item_data = active_r_hand_item_data
		ItemData.HandSlot.LEFT_HAND:
			_equip_to_slot(pending_equip, l_hand_socket_marker, current_l_hand_equip, func(equippable: Equippable3D): current_l_hand_equip = equippable)
			active_l_hand_item_data = pending_equip
			current_active_item_data = active_l_hand_item_data
		ItemData.HandSlot.TWO_HANDED:
			_clear_slot(current_l_hand_equip, func(): current_l_hand_equip = null)
			_equip_to_slot(pending_equip, r_hand_socket_marker, current_r_hand_equip, func(equippable: Equippable3D): current_r_hand_equip = equippable)
			active_2_hands_item_data = pending_equip
			current_active_item_data = active_2_hands_item_data
		
	item_equip_finished.emit(current_active_item_data)
	GameEvents.item_equipped.emit(current_active_item_data)
	pending_equip = null
	
func remove_pending_unequip() -> void:
	var unequipped_item_data: ItemData
	
	match pending_unequip.hand_slot:
		ItemData.HandSlot.LEFT_HAND:
			unequipped_item_data = active_l_hand_item_data
			_clear_slot(current_l_hand_equip, func(): 
				current_l_hand_equip = null
				active_l_hand_item_data = null
			)
		ItemData.HandSlot.RIGHT_HAND:
			unequipped_item_data = active_r_hand_item_data
			_clear_slot(current_r_hand_equip, func(): 
				current_r_hand_equip = null
				active_r_hand_item_data = null	
			)
		ItemData.HandSlot.TWO_HANDED:
			unequipped_item_data = active_2_hands_item_data
			_clear_slot(current_r_hand_equip, func(): 
				current_r_hand_equip = null
				active_2_hands_item_data = null
			)
		
	if unequipped_item_data:
		item_unequip_finished.emit(unequipped_item_data)
		GameEvents.item_unequip.emit(unequipped_item_data)
		
func stash() -> void:
	_is_input_disabled = true
	
	if current_r_hand_equip:
		current_r_hand_equip.hide()
	
	if current_l_hand_equip:
		current_l_hand_equip.hide()

func unstash() -> void:
	if current_r_hand_equip:
		current_r_hand_equip.show()
		
	if current_l_hand_equip:	
		current_l_hand_equip.show()
	
	_is_input_disabled = false
		
func _equip_to_slot(new_item: ItemData, socket: Marker3D, current_item: Equippable3D, assign_callback: Callable) -> void:
	if current_item:
		current_item.on_unequip()
		current_item.queue_free()
		
	var equippable := new_item.equip_scene.instantiate() as Equippable3D
	socket.add_child(equippable)
	equippable.on_equip()
	
	assign_callback.call(equippable)

func _clear_slot(current_item: Equippable3D, clear_callback: Callable) -> void:
	if current_item:
		current_item.on_unequip()
		current_item.queue_free()
		clear_callback.call()
		
func _input(event: InputEvent) -> void:
	if get_tree().paused or _is_input_disabled: return
	
	if event.is_action_pressed("left_hand_action"):
		if current_r_hand_equip and active_2_hands_item_data:
			current_r_hand_equip.secondary_action()
			return
		if current_l_hand_equip:
			current_l_hand_equip.primary_action()
		
	if event.is_action_pressed("right_hand_action"):
		if current_r_hand_equip:
			current_r_hand_equip.primary_action()
 
