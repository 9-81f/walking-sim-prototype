class_name TweenHelpers extends Node	

static func scale_x(node: Node2D, reverse_playback: bool = false, duration: float = 1.0, target_x: float = 1.0) -> Tween:
	var tween := node.create_tween()
	tween.tween_property(node, "scale:x", 0.0 if reverse_playback else target_x , duration)
	tween.set_ease(Tween.EASE_IN_OUT)
	return tween
	
static func rotate_45_deg_from_center(node: Node2D, duration: float = 1.0, target_deg: int = 45) -> Tween:
	var tween := node.create_tween()
	tween.tween_property(node, "rotation_degrees", target_deg, duration)
	tween.tween_property(node, "rotation_degrees", -target_deg, duration)
	tween.tween_property(node, "rotation_degrees", 0.0, duration)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	return tween
	
static func light_2d_single_flicker(node: Light2D, reverse_playback: bool = false, default_energy: float = 1.0, duration: float = 0.35) -> Tween:
	var tween := node.create_tween()
	
	tween.tween_property(node, "energy", 0.0 if reverse_playback else default_energy, duration)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	return tween
	
static func light_2d_flicker(node: Light2D, reverse_playback: bool = false, default_energy: float = 1.0) -> Tween:
	var tween := node.create_tween()

	for i in range(4):
		tween.tween_property(node, "energy", 0.0 if reverse_playback else default_energy, 0.15)
		tween.tween_property(node, "energy", default_energy if reverse_playback else 0.0, 0.15)

	tween.tween_property(node, "energy", 0.0 if reverse_playback else default_energy, 0.35)
	
	return tween
