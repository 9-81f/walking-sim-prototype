extends Toggleable3D
class_name LightToggleComponent

@export var _light_source: Light3D
@export var _audio_player: AudioStreamPlayer3D
@export var _default_stream: AudioStream = preload("res://assets/sfx/ui-audio/switch4.ogg")

func _ready() -> void:
	assert(_light_source != null, "[LightToggleComponent]: Light Source is expected but not found. Assign Light Source to inspector!")
	_light_source.visible = _controller.is_toggled
	
	if _audio_player:
		_audio_player.stream = _default_stream
	
	super._ready()

func _on_switch_toggled(toggled: bool) -> void:
	if toggled:
		_light_source.show()
	else:
		_light_source.hide()
	
	if _audio_player and not _audio_player.playing:
		_audio_player.play()
