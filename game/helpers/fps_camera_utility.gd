extends Node3D
class_name FPSCameraUtility

@export_category("Dependencies")
@export var _motion: MotionComponent3D
@export var _camera: Camera3D

@export_category("Headbob Settings")
@export var _bob_freq := 5.0
@export var _bob_ampl := 0.025
@export var _step_decay := 5.0

var _bob_timer := 0.0
var _initial_camera_transform: Vector3

func _ready() -> void:
	if _camera:
		_initial_camera_transform = _camera.position

func _process(delta: float) -> void:
	handle_bob(delta)

func handle_bob(delta: float) -> void:
	if not _camera or not _motion: return

	if _motion.is_moving() and _motion._body.is_on_floor():
		var current_speed := _motion._body.velocity.length()
		_bob_timer += delta * current_speed
		
		var bob_y := sin(_bob_timer * _bob_freq * 0.5) * _bob_ampl
		var bob_x := cos(_bob_timer * _bob_freq * 0.25) * (_bob_ampl * 0.5)
		
		_camera.position.y = _initial_camera_transform.y + bob_y
		_camera.position.x = _initial_camera_transform.x + bob_x
	else:
		_bob_timer = 0.0
		
		_camera.position.y = move_toward(_camera.position.y, _initial_camera_transform.y, _step_decay * delta)
		_camera.position.x = move_toward(_camera.position.x, _initial_camera_transform.x, _step_decay * delta)
		
