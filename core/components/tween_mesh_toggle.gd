extends Toggleable3D
class_name TweenMeshToggleComponent

@export var _node_to_tween: Node3D
@export var _tween_property: NodePath = "rotation_degrees:y"
@export var _default_tween_value := 0.0
@export var _target_tween_value := 90.0
@export var _locked_state_tween_offset := 1.5
@export var _tween_duration := 0.5
@export var _tween_ease: Tween.EaseType = Tween.EASE_IN_OUT
@export var _tween_trans: Tween.TransitionType = Tween.TRANS_CUBIC

func _on_switch_toggled(toggled: bool) -> void:
	if toggled:
		_tween_toggled_on()
	else:
		_tween_toggled_off()
		
func _on_switch_locked(_unlocked: bool) -> void:
	_controller.is_tweening = true
	
	var tween := _node_to_tween.create_tween()
	tween.set_ease(_tween_ease).set_trans(_tween_trans)
	tween.tween_property(_node_to_tween, _tween_property, _default_tween_value + _locked_state_tween_offset, _tween_duration/2)
	tween.tween_property(_node_to_tween, _tween_property, _default_tween_value - _locked_state_tween_offset, _tween_duration/2)
	tween.tween_property(_node_to_tween, _tween_property, _default_tween_value, _tween_duration/2)
	
	await tween.finished
	
	_controller.is_tweening = false
	
func _tween_toggled_on() -> void:
	_controller.is_tweening = true
	
	var tween := _node_to_tween.create_tween()
	tween.set_ease(_tween_ease).set_trans(_tween_trans)
	tween.tween_property(_node_to_tween, _tween_property, _target_tween_value, _tween_duration)
	
	await tween.finished
	
	_controller.is_tweening = false

func _tween_toggled_off() -> void:
	_controller.is_tweening = true
	
	var tween := _node_to_tween.create_tween()
	tween.set_ease(_tween_ease).set_trans(_tween_trans)
	tween.tween_property(_node_to_tween, _tween_property, _default_tween_value, _tween_duration)
	
	await tween.finished
	
	_controller.is_tweening = false
