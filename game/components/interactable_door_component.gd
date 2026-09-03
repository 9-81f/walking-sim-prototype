extends InteractableEnclosure3D
class_name InteractableDoorComponent

@export var _audio: AudioStreamPlayer3D
@export var _open_sfx: AudioStream = preload("res://assets/sfx/rpg-audio/doorOpen_1.ogg")
@export  var _close_sfx: AudioStream = preload("res://assets/sfx/rpg-audio/doorClose_4.ogg")
@export var _locked_sfx: AudioStream = preload("res://assets/sfx/rpg-audio/doorClose_2.ogg")

func _ready() -> void:
	super._ready()
	
	if is_opened:
		if _audio:
			_audio.stream = _close_sfx
		_mesh_to_tween.rotation_degrees.y = _target_tween_prop_value
		opened.emit()
	else:
		if _audio:
			_audio.stream = _open_sfx
		_mesh_to_tween.rotation_degrees.y = _default_tween_prop_value
		closed.emit()
	
func open() -> void:
	if _audio:
		_audio.stream = _open_sfx
		_audio.play()
	super.open()
	
func close() -> void:
	if _audio:
		_audio.stream = _close_sfx
		_audio.play()
	super.close()
	
func _tween_mesh(target_angle: float, ease_type: Tween.EaseType) -> void:		
	_is_tweening = true
	
	var tween := _mesh_to_tween.create_tween();
	tween.set_ease(ease_type).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(_mesh_to_tween, "rotation_degrees:y", target_angle, _enclosure_tween_duration)
	
	await tween.finished
	
	_is_tweening = false
	
func _tween_lock_jitter() -> void:
	if _audio:
		_audio.stream = _locked_sfx
		_audio.play()
	
	_is_tweening = true
	
	var tween:= _mesh_to_tween.create_tween()
	
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_mesh_to_tween, "rotation_degrees:y", _default_tween_prop_value + 1.5, _lock_jitter_tween_duration)
	tween.tween_property(_mesh_to_tween, "rotation_degrees:y", _default_tween_prop_value - 1.5, _lock_jitter_tween_duration)
	tween.tween_property(_mesh_to_tween, "rotation_degrees:y", _default_tween_prop_value, _lock_jitter_tween_duration)
	
	await tween.finished
	
	_is_tweening = false
