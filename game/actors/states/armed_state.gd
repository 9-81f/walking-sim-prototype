extends State
class_name ArmedState

@export var equip: EquipComponent
@export var anim: AnimationComponent

func enter() -> void:
	if equip:
		var item_to_equip := equip.pending_equip
		
		if not item_to_equip:
			set_state(&"UnarmedState", self)
		else:
			equip.attach_pending_equip()
	
	if anim:
		anim.set_action_one_shot("melee_draw")
		anim.set_hand_pose("r_hand_pose", "melee_idle")
