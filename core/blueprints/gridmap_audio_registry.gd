extends Resource
class_name GridMapSurfaceAudioRegistry

@export var registry: Dictionary[int, AudioStream]

func get_audio_stream(index: int) -> AudioStream:
	if index == GridMap.INVALID_CELL_ITEM:
		return null
	return registry[index]
