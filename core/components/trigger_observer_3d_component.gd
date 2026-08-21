extends Area3D
class_name TriggerObserverComponent

func _ready() -> void:
	set_collision_layer_value(1, false)
	set_collision_mask_value(11, true)
