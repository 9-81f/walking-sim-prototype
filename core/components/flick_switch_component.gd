extends Toggleable3D
class_name FlickSwitchComponent

@export var _mesh_to_tween: MeshInstance3D
@export var _default_prop_value := 0.0
@export var _target_prop_value := -15.0
@export var _tween_duration := 0.15

var is_tweening := false

func _on_switch_toggled(toggled: bool) -> void:
	if toggled:
		_tween_toggle_on()
	else:
		_tween_toggle_off()
		
func _tween_toggle_on() -> void:
	is_tweening = true
	
	var tween := _mesh_to_tween.create_tween()
	tween.tween_property(_mesh_to_tween, "rotation_degrees:z", _target_prop_value, _tween_duration)
	
	await tween.finished
	
	is_tweening = false
	
func _tween_toggle_off() -> void:
	is_tweening = true
	
	var tween := _mesh_to_tween.create_tween()
	tween.tween_property(_mesh_to_tween, "rotation_degrees:z", _default_prop_value, _tween_duration)
	
	await tween.finished
	
	is_tweening = false
