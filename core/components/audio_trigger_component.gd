extends Node3D
class_name AudioTriggerComponent3D

@export var _trigger_area: TriggerArea3D
@export var _audio_player: AudioStreamPlayer3D
@export var _entered_stream: AudioStream
@export var _exited_stream: AudioStream

func _ready() -> void:
	if _trigger_area:
		_trigger_area.observer_entered.connect(_on_observer_entered)
		_trigger_area.observer_exited.connect(_on_observer_exited)
		
func _on_observer_entered() -> void:
	if _entered_stream and _audio_player:
		_audio_player.stream = _entered_stream
		_audio_player.play()
		
func _on_observer_exited() -> void:
	if _exited_stream and _audio_player:
		_audio_player.stream = _exited_stream
		_audio_player.play()
