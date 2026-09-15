extends Control
class_name EndGameModal

@onready var button: Button = $PanelContainer/CenterContainer/PanelContainer/VBoxContainer/Button

func _ready() -> void:
	hide()
	button.pressed.connect(
		func():
			InventoryDataManager.clear()
		
			get_tree().paused = false
			
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
			get_tree().reload_current_scene()
)


func trigger_modal() -> void:
	show()
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	get_tree().paused = true
