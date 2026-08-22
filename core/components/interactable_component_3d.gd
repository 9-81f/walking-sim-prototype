extends Area3D
class_name Interactable3D

signal focused(interactor: Node3D)
signal interacted(interactor: Node3D)
signal blurred(interactor: Node3D)

@export var prompt_message := "Interact"
@export var is_enabled := true
@export var input_icon: Texture2D = preload("res://assets/icons/keyboard_mouse_input_prompts/Default/keyboard_f.png")

var _is_focused := false

class PromptData:
	var prompt_message: String
	var prompt_icon: Texture2D
	
	func _init(message: String, icon: Texture2D) -> void:
		prompt_message = message
		prompt_icon = icon

func get_prompt() -> PromptData:
	return PromptData.new(prompt_message, input_icon)

func focus(interactor: Node3D) -> void:
	if not is_enabled: return
	_is_focused = true
	UiEvents.display_interaction_prompt_requested.emit(get_prompt())
	focused.emit(interactor)
	
func interact(interactor: Node3D) -> void:
	if not is_enabled: return
	if _is_focused:
		UiEvents.display_interaction_prompt_requested.emit(get_prompt())
	else:
		UiEvents.dismiss_interaction_prompt_requested.emit()
	interacted.emit(interactor)
	
func blur(interactor: Node3D) -> void:
	_is_focused = false
	UiEvents.dismiss_interaction_prompt_requested.emit()
	blurred.emit(interactor)
	
func _exit_tree() -> void:
	UiEvents.dismiss_interaction_prompt_requested.emit()
