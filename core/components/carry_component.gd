extends Node
class_name CarryComponent

signal carried
signal dropped

@export var carry_marker: Marker3D
@export var carried_prompt_icon: Texture2D = preload("res://assets/icons/keyboard_mouse_input_prompts/Double/keyboard_g.png")
@export var carried_prompt_message := "Drop"

var is_carrying: WorldPickup = null

func set_to_socket(world_pickup: WorldPickup) -> void:
	if is_carrying:
		drop_to_world()
	
	var tween := world_pickup.create_tween()
			
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(world_pickup, "global_position", carry_marker.global_position, 0.1)
	
	await tween.finished
	
	world_pickup.reparent(carry_marker)
	world_pickup.interactable.set_collision_layer_value(10, false)
	world_pickup.freeze = true
	
	is_carrying = world_pickup
	
	carried.emit()
	
	UiEvents.toast_requested.emit(carried_prompt_message, carried_prompt_icon)
	
func _physics_process(_delta: float) -> void:
	if is_carrying:
		is_carrying.global_rotation = Vector3.ZERO
		
func drop_to_world() -> void:
	is_carrying.reparent(get_tree().current_scene)
	is_carrying.freeze = false
	is_carrying.interactable.set_collision_layer_value(10, true)
	is_carrying.display_standing = true
	
	is_carrying = null
	
	dropped.emit()

func _unhandled_input(event: InputEvent) -> void:
	if get_tree().paused or not is_carrying: return
	
	if event.is_action_pressed("inventory_drop"):
		drop_to_world()
