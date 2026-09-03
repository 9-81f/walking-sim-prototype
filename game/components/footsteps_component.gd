extends RayCast3D
class_name FootstepsComponent

@export var _player: AudioStreamPlayer3D
@export var _step_distance := 1.8
@export var _default_data: SurfaceAudioData
@export var _surface_data_list: Array[SurfaceAudioData] = []

var _distance_accumulated := 0.0

func update_footsteps(delta: float, velocity: Vector3, is_on_floor: bool) -> void:
	var horizontal_velocity := Vector3(velocity.x, 0.0, velocity.z)
	
	if not is_on_floor and horizontal_velocity.length_squared() < 0.05:
		_distance_accumulated = 0.0
		return
	
	_distance_accumulated += horizontal_velocity.length() * delta
	
	if _distance_accumulated >= _step_distance:
		_distance_accumulated = 0.0
		play_step()

func play_step() -> void:
	if not is_colliding() or not _player: return
	
	var collider := get_collider()
	var stream_to_play := _resolve_surface_audio_stream(collider)
	
	if stream_to_play:
		_player.stream = stream_to_play
		_player.play()

func _resolve_surface_audio_stream(collider: Object) -> AudioStream:
	if not collider:
		return _default_data.audio_stream
		
	if collider is StaticBody3D:
		var phys_mat := collider.physics_material_override as PhysicsMaterial
		
		if not phys_mat:
			return _default_data.audio_stream
		
		for data in _surface_data_list:
			if data.physics_material == phys_mat:
				return data.audio_stream
		
	return _default_data.audio_stream
