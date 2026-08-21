extends PanelContainer
class_name Toast

@export var _fade_duration := 0.25
@export var _display_duration := 3.0

@onready var toast_message: Label = $MarginContainer/HBoxContainer/ToastMessage
@onready var toast_icon: TextureRect = $MarginContainer/HBoxContainer/ToastIcon

var _full_height := 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	clip_contents = true
	
func setup(message: String, icon: Texture2D = null) -> void:
	if icon:
		toast_icon.texture = icon
		toast_icon.show()
	else:
		toast_icon.hide()
		
	if message: toast_message.text = message
	
	_transition_in()
	
func _transition_in() -> void:
	_full_height = get_combined_minimum_size().y
	
	modulate.a = 0.0
	custom_minimum_size.y = 0.0
	
	var tween := self.create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

	tween.tween_property(self, "modulate:a", 1.0, _fade_duration)
	tween.tween_property(self, "custom_minimum_size:y", _full_height, _fade_duration)
	
	await tween.finished
	
	get_tree().create_timer(_display_duration).timeout.connect(_transition_out)
	
func _transition_out() -> void:
	var tween := self.create_tween().set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(self, "custom_minimum_size:y", 0.0, _fade_duration)
	tween.tween_property(self, "modulate:a", 0.0, _fade_duration)
	
	await tween.finished
	
	queue_free()
	
