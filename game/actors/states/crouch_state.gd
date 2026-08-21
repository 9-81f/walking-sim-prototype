extends State
class_name CrouchState

@export var _motion: MotionComponent3D
@export var _input: InputComponent
@export var _collision_shape: CollisionShape3D
@export var _tag_along: Node3D

func enter() -> void:
	_motion.crouch(_collision_shape, true, _tag_along)

func physics_update(_delta: float) -> void:
	if _motion.is_on_floor() and _motion.has_headroom():
		if _input.is_run_pressed() and _motion.can_run:
			set_state(&"RunState", self)
			
		if _input.is_jump_pressed() and _motion.can_jump:
			set_state(&"JumpState", self)
			
		if _input.is_crouch_pressed() and _motion.can_crouch:
			if _motion.is_moving():
				set_state(&"WalkState", self)
				
			set_state(&"IdleState", self)

func exit() -> void:
	_motion.crouch(_collision_shape, false, _tag_along)
