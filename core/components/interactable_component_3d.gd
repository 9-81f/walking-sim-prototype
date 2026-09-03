extends Area3D
class_name Interactable3D

signal focused(interactor: Node3D)
signal interacted(interactor: Node3D)
signal blurred(interactor: Node3D)

@export var is_enabled := true

@export_category("Prompt Display Settings")
@export var _enable_interaction_prompt_display := true
@export var prompt_message := "Interact"
@export var input_icon: Texture2D = preload("res://assets/icons/keyboard_mouse_input_prompts/Default/keyboard_f.png")
@export var is_in_active_room := true

@export_category("Spatial Prompt Add-on")
@export var _spatial_prompt: SpatialPromptComponent

var _is_focused := false
var is_player_nearby := false

class PromptData:
	var prompt_message: String
	var prompt_icon: Texture2D
	
	func _init(message: String, icon: Texture2D) -> void:
		prompt_message = message
		prompt_icon = icon
		
func _ready() -> void:
	set_collision_layer_value(10, true)

func get_prompt() -> PromptData:
	return PromptData.new(prompt_message, input_icon)
	
func update_prompt_state() -> void:
	if not _spatial_prompt: return
	
	if not is_enabled or not is_in_active_room:
		_spatial_prompt.clear_texture()
		return
	
	if is_player_nearby:
		_spatial_prompt.show_prompt(_is_focused)
	else:
		_spatial_prompt.clear_texture()

func focus(interactor: Node3D) -> void:
	_is_focused = true
	
	update_prompt_state()
	
	focused.emit(interactor)
	
	if _enable_interaction_prompt_display:
		UiEvents.display_interaction_prompt_requested.emit(get_prompt())
	
	
func interact(interactor: Node3D) -> void:
	if not is_enabled or not is_in_active_room: return
	
	interacted.emit(interactor)
	
	update_prompt_state()
	
func blur(interactor: Node3D) -> void:
	_is_focused = false
	
	update_prompt_state()
		
	blurred.emit(interactor)
	
	if _enable_interaction_prompt_display:
		UiEvents.dismiss_interaction_prompt_requested.emit()
	
	
func set_room_active(active: bool) -> void:
	is_in_active_room = active
	update_prompt_state()
	
func _exit_tree() -> void:
	if not _enable_interaction_prompt_display: return
	UiEvents.dismiss_interaction_prompt_requested.emit()
