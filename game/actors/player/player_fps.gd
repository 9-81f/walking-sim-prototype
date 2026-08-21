extends CharacterBody3D
class_name PlayerFPS

@onready var head: Node3D = $FPSCameraUtility/Camera3D
@onready var standing_height_point: Node3D = $FPSCameraUtility
@onready var carry_marker: Marker3D = $FPSCameraUtility/Camera3D/CarryMarker
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var motion: MotionComponent3D = $MotionComponent3D
@onready var input: InputComponent = $InputComponent
@onready var interactor: Interactor3D = $Interactor3D
@onready var locomotion_fsm: FiniteStateMachineComponent = $LocomotionFSM
@onready var action_fsm: FiniteStateMachineComponent = $ActionFSM
@onready var equip: EquipComponent = $EquipComponent
@onready var carry: CarryComponent = $CarryComponent
@onready var health: HealthComponent = $HealthComponent

func _ready() -> void:
	motion.initialize(self, collision_shape.shape.height, standing_height_point.position.y)
	UiEvents.item_use_requested.connect(_on_item_use_requested)
	UiEvents.item_drop_requested.connect(_on_item_drop_requested)
	UiEvents.item_stow_requested.connect(_on_item_stow_requested)
	equip.item_equip_started.connect(_on_item_equip_started)
	equip.item_unequip_started.connect(_on_item_unequip_started)
	carry.carried.connect(_on_carried)
	carry.dropped.connect(_on_carry_dropped)
	
func _physics_process(delta: float) -> void:
	motion.apply_gravity(delta);
	motion.set_direction(input.get_input_vector_directions("move_left", "move_right", "move_up", "move_down"))
	motion.move(delta)
	motion.turn_x_towards_point(self, input.get_mouse_motion_direction())
	motion.turn_y_towards_point(head, input.get_mouse_motion_direction())
	input.reset_mouse_motion_direction()

func _on_item_drop_requested(item: ItemData, qty: int) -> void:
	# NOTE: can add unequip from EquipComponent if item removed is equipped
	if not item: return
	
	if item.type == ItemData.ItemType.EQUIPPABLE:
		if equip.is_equipping(): 
			UiEvents.toast_requested.emit("Unable to drop equipped items.", null)
			return
	
	var removed_amount := InventoryDataManager.remove(item, qty);
	
	if removed_amount > 0:
		var item_name := InventoryDataManager.get_pluralized_item_name(item, removed_amount)
		UiEvents.toast_requested.emit("Dropped %dx %s from inventory." % [removed_amount, item_name], item.icon)
		for n in removed_amount:
			InventoryDataManager.spawn_drop(item, carry_marker.global_position)

func _on_item_use_requested(item: ItemData, _qty: int) -> void:
	if item.type == ItemData.ItemType.EQUIPPABLE:
		equip.request_equip(item)
	else:
		if _apply_consumable_effects(item):
			InventoryDataManager.remove(item, 1)
	
func _on_item_stow_requested(item: ItemData, _qty: int) -> void:
	equip.request_unequip(item)

func _on_item_equip_started(_item: ItemData) -> void:
	action_fsm.transition_state(&"ArmedState")
	
func _on_item_unequip_started(_item: ItemData) -> void:
	action_fsm.transition_state(&"UnarmedState")
	
func _on_carried() -> void:
	action_fsm.transition_state(&"CarryState")
	
func _on_carry_dropped() -> void:
	if action_fsm.current_state is CarryState:
		if equip.is_equipping():
			action_fsm.transition_state(&"ArmedState")
		else:
			action_fsm.transition_state(&"UnarmedState")
	
func _apply_consumable_effects(item: ItemData) -> bool:
	if item.type != ItemData.ItemType.CONSUMABLE: return false
	
	if item.stats_modifiers.keys().size() > 0:
		var stat_modifier := item.stats_modifiers
		var effect_applied := false
		
		for modifier in item.stats_modifiers.keys():
			var effect = stat_modifier[modifier]
			match modifier:
				"heal":
					if health.is_health_full(): 
						UiEvents.toast_requested.emit("Health is full!", null)
						return false
					health.heal(effect)
					effect_applied = true
					UiEvents.toast_requested.emit("Consumed %s. Healed +%d." % [item.display_name, effect], item.icon)
					
		return effect_applied
		
	return false
