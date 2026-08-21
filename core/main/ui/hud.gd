extends CanvasLayer
class_name HUD

@onready var interaction_prompt: InteractionPrompt = $Prompts/InteractionPrompt
@onready var inventory_ui: InventoryUI = $Windows/InventoryUI
@onready var health_bar: ProgressBar = $Bars/VBoxContainer/HealthBar

func _ready() -> void:
	interaction_prompt.hide()

func show_prompt(prompt_data: Interactable3D.PromptData) -> void:
	interaction_prompt.setup(prompt_data.prompt_message, prompt_data.prompt_icon)
	interaction_prompt.show()
	
func hide_prompt() -> void:
	interaction_prompt.hide()
	interaction_prompt.clear()
