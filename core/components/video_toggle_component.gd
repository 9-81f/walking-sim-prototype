extends Toggleable3D
class_name VideoToggleComponent

@export var _video_stream: VideoStream
@export var _video_player: VideoStreamPlayer
@export var _mesh: MeshInstance3D
@export var _screen_mat_index := 1

func _on_switch_toggled(toggled: bool) -> void:
	if toggled:
		_video_player.stream = _video_stream
		_video_player.play()
	else:
		_video_player.stop()
		_video_player.stream = null
		
	var mat := _mesh.get_active_material(_screen_mat_index) as StandardMaterial3D
	
	if mat:
		mat.emission_enabled = toggled
