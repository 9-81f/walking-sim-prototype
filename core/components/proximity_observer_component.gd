extends Area3D
class_name ProximityObserverComponent

func _ready() -> void:
	set_collision_mask_value(10, true)
	area_entered.connect(_on_proximity_area_entered)
	area_exited.connect(_on_proximity_area_exited)

func _on_proximity_area_entered(area: Area3D) -> void:
	if area is Interactable3D:
		area.is_player_nearby = true
		area.update_prompt_state()
			
func _on_proximity_area_exited(area: Area3D) -> void:
	if area is Interactable3D:
		area.is_player_nearby = false
		area.update_prompt_state()
