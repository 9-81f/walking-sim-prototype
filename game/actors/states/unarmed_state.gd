extends State
class_name UnarmedState

@export var equip: EquipComponent
@export var anim: AnimationComponent

func enter() -> void:
	if equip:
		var item_to_unequip: ItemData = equip.pending_unequip

		if item_to_unequip:
			if anim:
				anim.set_action_one_shot("melee_stow")
				anim.set_hand_pose("r_hand_pose", "rest")
			else:
				equip.remove_pending_unequip()
