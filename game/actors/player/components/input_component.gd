extends Node
class_name InputComponent

@export var mouse_captured := true
var _mouse_direction := Vector2.ZERO

func _process(_delta: float) -> void:
	if mouse_captured:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func get_input_vector_directions(neg_x: StringName = "ui_left", pos_x: StringName = "ui_right", neg_y: StringName = "ui_up", pos_y: StringName = "ui_down", deadzone: float = -1.0) -> Vector2:
	return Input.get_vector(neg_x, pos_x, neg_y, pos_y, deadzone);
	
func get_input_axis_directions(neg_action: StringName = "ui_left", pos_action: StringName ="ui_right") -> float:
	return Input.get_axis(neg_action, pos_action)

func get_mouse_motion_direction(sens: float = 0.002) -> Vector2:
	return _mouse_direction * sens
	
func reset_mouse_motion_direction() -> void:
	_mouse_direction = Vector2.ZERO
	
func is_run_pressed() -> bool:
	return Input.is_action_pressed("sprint");
	
func is_jump_pressed() -> bool:
	if get_tree().paused: return false
	return Input.is_action_just_pressed("jump");
	
func is_crouch_pressed() -> bool:
	if get_tree().paused: return false
	return Input.is_action_just_pressed("crouch");
	
func _input(event: InputEvent) -> void:
	if get_tree().paused: return
	
	if event.is_action_pressed("ui_cancel"):
		mouse_captured = !mouse_captured
		
	if event is InputEventMouseMotion:
		_mouse_direction = event.relative
