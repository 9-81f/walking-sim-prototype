extends InteractableEnclosure3D
class_name InteractableDoorComponent

func _ready() -> void:
	super._ready()
	
	if is_opened:
		_mesh_to_tween.rotation_degrees.y = _target_tween_prop_value
		opened.emit()
	else:
		_mesh_to_tween.rotation_degrees.y = _default_tween_prop_value
		closed.emit()
	
func _tween_mesh(target_angle: float, ease_type: Tween.EaseType) -> void:
	_is_tweening = true
	
	var tween := _mesh_to_tween.create_tween();
	tween.set_ease(ease_type).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(_mesh_to_tween, "rotation_degrees:y", target_angle, _enclosure_tween_duration)
	
	await tween.finished
	
	_is_tweening = false
	
func _tween_lock_jitter() -> void:
	var init_y := _mesh_to_tween.rotation_degrees.y
	
	var tween:= _mesh_to_tween.create_tween()
	
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_mesh_to_tween, "rotation_degrees:y", init_y + 1.5, _lock_jitter_tween_duration)
	tween.tween_property(_mesh_to_tween, "rotation_degrees:y", init_y - 1.5, _lock_jitter_tween_duration)
	tween.tween_property(_mesh_to_tween, "rotation_degrees:y", init_y, _lock_jitter_tween_duration)
