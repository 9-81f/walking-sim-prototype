extends Node3D
class_name Main

@onready var _player: PlayerFPS = $PlayerFPS
@onready var _hud: HUD = $HUD

func _ready() -> void:
	if _player:
		if _player.health:
			_hud.health_bar.max_value = _player.health.max_health
			_hud.health_bar.value = _player.health.current_health
			_player.health.health_changed.connect(_on_health_changed)
	_hud.inventory_ui.equip = _player.equip
	UiEvents.display_interaction_prompt_requested.connect(_on_display_interaction_prompt_requested)
	UiEvents.dismiss_interaction_prompt_requested.connect(_on_dismiss_interaction_prompt_requested)
	
func _on_display_interaction_prompt_requested(prompt_data: Interactable3D.PromptData) -> void:
	_hud.show_prompt(prompt_data)
	
func _on_dismiss_interaction_prompt_requested() -> void:
	_hud.hide_prompt()

func _on_health_changed(current_health: float, current_max_health: float, _change_amount: float) -> void:
	##NOTE: Use change_amount to display damage ui
	if _hud.health_bar.max_value != current_max_health:
		_hud.health_bar.max_value = current_max_health
	_hud.health_bar.value = current_health
