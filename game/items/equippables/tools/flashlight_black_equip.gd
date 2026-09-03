extends Equippable3D
class_name FlashlightBlackEquip

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var spotlight: SpotLight3D = $SpotLight3D
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

var _audio_stream := preload("res://assets/sfx/ui-audio/switch5.ogg")

var is_toggled := false

func _ready() -> void:
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	audio_player.stream = _audio_stream
	spotlight.hide()
	
func primary_action() -> void:
	is_toggled = !is_toggled
	if is_toggled:
		spotlight.show()
	else:
		spotlight.hide()
	
	audio_player.play()
