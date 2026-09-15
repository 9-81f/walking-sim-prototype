extends CanvasLayer
class_name HUD

@onready var interaction_prompt: InteractionPrompt = $Prompts/InteractionPrompt
@onready var inventory_ui: InventoryUI = $Windows/InventoryUI
@onready var health_bar: ProgressBar = $Bars/VBoxContainer/HealthBar
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var tutorial: Control = $Tutorial

func _ready() -> void:
	tutorial.show()
	audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	UiEvents.ui_audio_requested.connect(_on_ui_audio_requested)
	inventory_ui.visibility_changed.connect(
		func():
			if inventory_ui.visible:
				tutorial.hide()
	)
	interaction_prompt.hide()

func show_prompt(prompt_data: Interactable3D.PromptData) -> void:
	interaction_prompt.setup(prompt_data.prompt_message, prompt_data.prompt_icon)
	interaction_prompt.show()
	
func hide_prompt() -> void:
	interaction_prompt.hide()
	interaction_prompt.clear()
	
func _on_ui_audio_requested(stream: AudioStream) -> void:
	audio_player.stream = stream
	audio_player.play()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("tutorial_window"):
		if tutorial.visible:
			tutorial.hide()
		else:
			tutorial.show()
