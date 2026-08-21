extends Node
class_name AnimationComponent

@export var anim_tree: AnimationTree

const ACTIONS = {
	"push": 0,
	"grab": 1,
	"melee_draw": 2,
	"melee_stow": 3
}

const HAND_POSES = {
	"rest": 0,
	"melee_idle": 1
}

func set_hand_pose(hand_slot: String, pose_name: String = "rest") -> void:
	if not anim_tree and not HAND_POSES.has(pose_name): return
	var idx := HAND_POSES[pose_name] as int
	anim_tree.set("parameters/%s/transition_request" % hand_slot, str(idx))
	
func set_action_one_shot(action_name: String) -> void:
	if not anim_tree and not ACTIONS.has(action_name): return
	var idx := ACTIONS[action_name] as int
	anim_tree.set(&"parameters/actions/transition_request", str(idx))
	anim_tree.set(&"parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
