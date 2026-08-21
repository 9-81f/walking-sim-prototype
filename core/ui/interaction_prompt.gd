extends PanelContainer
class_name InteractionPrompt

@onready var prompt_icon: TextureRect = $HBoxContainer/PromptIcon
@onready var prompt_message: Label = $HBoxContainer/PromptMessage

func _ready() -> void:
	hide()
	
func setup(text: String, icon: Texture2D) -> void:
	if icon:
		prompt_icon.texture = icon
	else:
		push_error("[InteractionPrompt]: prompt_icon required!")
	
	if text:
		prompt_message.text = text
	else:
		push_error("[InteractionPrompt]: prompt_message required!")

func clear() -> void:
	prompt_icon.texture = null
	prompt_message.text = ""
