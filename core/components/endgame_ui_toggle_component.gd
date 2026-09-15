extends Toggleable3D
class_name EndGameUIToggleComponent

func _on_switch_toggled(toggled: bool) -> void:
	if toggled:
		UiEvents.end_game_modal_requested.emit()
