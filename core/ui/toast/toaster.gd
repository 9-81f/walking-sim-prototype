extends Control
class_name Toaster

@export var _toast_ui_scene: PackedScene
@onready var v_box_container: VBoxContainer = $VBoxContainer

func _ready() -> void:
	UiEvents.toast_requested.connect(_on_toast_requested)

func _on_toast_requested(message: String, icon: Texture2D) -> void:
	if not _toast_ui_scene:
		push_error("[Toaster]: Toast scene is not assigned in the Inspector!")
		return
		
	var toast := _toast_ui_scene.instantiate() as Toast
	v_box_container.add_child(toast)
	v_box_container.move_child(toast, 0)
	
	toast.setup(message, icon)
	
