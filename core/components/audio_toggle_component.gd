extends Toggleable3D
class_name AudioToggleComponent

@export var _audio: AudioStreamPlayer3D
@export var _on_sound: AudioStream = preload("res://assets/sfx/ui-audio/switch1.ogg")
@export var _off_sound: AudioStream = preload("res://assets/sfx/ui-audio/switch2.ogg")
@export var _locked_sound: AudioStream

func _on_switch_toggled(toggled: bool) -> void:
	if toggled:
		_audio.stream = _on_sound
	else:
		_audio.stream = _off_sound
	
	_audio.play()
	
func _on_switch_locked(_unlocked: bool) -> void:
	if _locked_sound:
		_audio.stream = _locked_sound
		_audio.play()
