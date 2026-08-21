extends State
class_name JumpState

@export var _motion: MotionComponent3D

func enter() -> void:
	_motion.jump()
	
func physics_update(_delta: float) -> void:
	if _motion.is_on_air() and _motion._body.is_on_floor():
		if _motion.is_moving():
			set_state(&"WalkState", self)
		else:
			set_state(&"IdleState", self)
