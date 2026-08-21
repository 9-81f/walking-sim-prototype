extends Node
class_name MotionComponent3D

@export_category("Base Physics")
@export var _base_speed := 10.0
@export var _base_rotation_speed := 10.0
@export var _base_acceleration := 40.0
@export var _base_friction := 50.0
@export var _base_jump_height := 15.0

@export_category("Air Physics")
@export var _air_acceleration := 50.0
@export var _air_friction := 5.0

@export_category("Crouch Settings")
@export_range(0.4, 0.8, 0.05) var _crouch_ratio := 0.55
@export_range(0.1, 2.0, 0.01) var _crouch_duration := 0.25
var _standing_height: float = 0.0
var _crouch_height: float = 0.0
var _tag_along_default_height: float = 0.0

@export_category("State Multiplier")
@export_range(0, 1, 0.1) var _walk_multiplier := 0.5
@export_range(1, 2, 0.25) var _run_multiplier := 1.0
@export_range(1.5, 4, 0.5) var _sprint_multiplier := 1.5
@export_range(0, 1, 0.05) var _crouch_multiplier := 0.15
@export_range(1.0, 10, 0.1) var _gravity_multiplier := 3.0

@export_category("Capability Toggles")
@export var can_run := true
@export var can_sprint := false
@export var can_jump := true
@export var can_crouch := true

@export_category("Add-Ons")
@export var ceiling_checker: RayCast3D

var is_running := false
var is_sprinting := false
var is_crouching := false

var current_speed: float

var _velocity_builder := Vector3.ZERO

var _body: CharacterBody3D = null
var _direction := Vector3.ZERO

func initialize(body: CharacterBody3D, standing_height: float, tag_along_default_height: float = 0.0) -> void:
	_body = body
	_standing_height = standing_height
	_crouch_height = _standing_height * _crouch_ratio
	if tag_along_default_height > 0.0:
		_tag_along_default_height = tag_along_default_height
	_dependency_check()

func _dependency_check() -> void:
	assert(_body != null, "[Motion Component]: Initialization failure. _body dependency is required!");	
	
func is_moving() -> bool:
	return _direction.length() > 0.0;
	
func is_on_floor() -> bool:
	return _body.is_on_floor()
	
func is_on_air() -> bool:
	return _body.velocity.y <= 0.0
	
func is_on_ceiling() -> bool:
	return _body.is_on_ceiling()
	
func has_headroom() -> bool:
	if not ceiling_checker: return true
	#print(not ceiling_checker.is_colliding())
	return not ceiling_checker.is_colliding()
	
func walk() -> void:
	is_running = false;
	is_sprinting = false;
	
func jump() -> void:
	_velocity_builder.y = _base_jump_height
	
func crouch(collision_shape: CollisionShape3D ,is_active: bool = true, tag_along: Node3D = null) -> void:
	is_crouching = is_active
	var shape := collision_shape.shape as CapsuleShape3D
	var target_height := _crouch_height if is_active else _standing_height
	var tween := get_tree().create_tween().set_parallel(true)
	tween.tween_property(shape, "height", target_height, _crouch_duration).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(collision_shape, "position:y", target_height / 2, _crouch_duration).set_ease(Tween.EASE_IN_OUT)
	if tag_along:
		var height_delta := _standing_height - _crouch_height
		var target_tag_along_height := _tag_along_default_height - height_delta
		tween.tween_property(tag_along, "position:y", target_tag_along_height  if is_active else _tag_along_default_height, _crouch_duration).set_ease(Tween.EASE_IN_OUT)
	
func stop() -> void:
	_velocity_builder = Vector3.ZERO

func get_current_speed() -> float:
	return current_speed

func get_gravity() -> float:
	return ProjectSettings.get_setting("physics/3d/default_gravity") * _gravity_multiplier
	
func set_direction(direction: Vector2) -> void: 
	_direction = (_body.transform.basis * Vector3(direction.x, 0.0, direction.y)).normalized()
	
func turn_towards_direction(looker: Node3D, delta: float, direction: Vector3 = _direction) -> void:
	if direction.length_squared() < 0.001: return
	var target_angle := atan2(direction.x, direction.z);
	looker.rotation.y = lerp_angle(looker.rotation.y, target_angle, _base_rotation_speed * delta)

func turn_x_towards_point(looker: Node3D, target: Vector2) -> void:
	if target.x == 0.0: return
	looker.rotate_y(-target.x)
	
func turn_y_towards_point(looker: Node3D, target: Vector2) -> void:
	if target.y == 0.0: return
	looker.rotation.x = clamp(looker.rotation.x - target.y, -1.0, 1.5)
	
func apply_gravity(delta: float) -> void:
	if _body.is_on_floor(): return
	_velocity_builder.y -= get_gravity() * delta
	
func move(delta: float) -> void:
	var applied_speed_multiplier := _walk_multiplier;
	
	if is_running: applied_speed_multiplier = _run_multiplier;
	elif is_sprinting: applied_speed_multiplier = _sprint_multiplier;
	elif is_crouching: applied_speed_multiplier = _crouch_multiplier;
	
	current_speed = _base_speed * applied_speed_multiplier
	var target_velocity := _direction * current_speed;
	var rate: float
	
	if _body.is_on_floor():
		rate = _base_acceleration if is_moving() else _base_friction
	else:
		rate = _air_acceleration if is_moving() else _air_friction
	
	_velocity_builder.x = move_toward(_velocity_builder.x, target_velocity.x, rate * delta);
	_velocity_builder.z = move_toward(_velocity_builder.z, target_velocity.z, rate * delta);
	
	_body.velocity = _velocity_builder
	_body.move_and_slide()
	
	_velocity_builder = _body.velocity
