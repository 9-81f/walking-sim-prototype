extends Sprite3D
class_name SpatialPromptComponent

@export var _unfocused_icon: Texture2D = preload("res://assets/icons/interaction_prompt_icon/circle-spatial-prompt-unfocused.png")
@export var _focused_icon: Texture2D = preload("res://assets/icons/interaction_prompt_icon/circle-spatial-prompt-focused.png")
@export var _display_position_y := 0.2

func _ready() -> void:
	scale = Vector3(0.02,0.02,0.02)
	position.y = _display_position_y
	billboard = BaseMaterial3D.BILLBOARD_ENABLED
	no_depth_test = true
	hide()

func show_prompt(focused: bool) -> void:
	var target_texture := _focused_icon if focused else _unfocused_icon
	
	if texture != target_texture:
		texture = target_texture
	
	show()
		
func clear_texture() -> void:
	texture = null
	hide()
