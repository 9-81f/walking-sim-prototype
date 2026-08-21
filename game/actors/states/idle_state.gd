extends State
class_name IdleState

@export var _motion: MotionComponent3D
@export var _input: InputComponent

func enter() -> void:
	_motion.stop()
	
func physics_update(_delta: float) -> void:
	if not _motion.is_on_floor(): return
	
	if _input.is_jump_pressed() and _motion.can_jump:
		set_state(&"JumpState", self)
		
	if _input.is_crouch_pressed() and _motion.can_crouch:
		set_state(&"CrouchState", self)
		
	if _motion.is_moving():
		if _input.is_run_pressed() and _motion.can_run:
			set_state(&"RunState", self)
		
		set_state(&"WalkState", self)
		
	
