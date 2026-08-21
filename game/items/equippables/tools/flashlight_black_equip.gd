extends Equippable3D
class_name FlashlightBlackEquip

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var spotlight: SpotLight3D = $SpotLight3D
var is_toggled := false

func _ready() -> void:
	spotlight.hide()
	
func primary_action() -> void:
	is_toggled = !is_toggled
	if is_toggled:
		spotlight.show()
	else:
		spotlight.hide()
