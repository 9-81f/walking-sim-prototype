extends State
class_name CarryState

#@export var _carry: CarryComponent
#
#func enter() -> void:
	#if _carry and _carry.is_carrying:
		#UiEvents.display_interaction_prompt_requested.emit(Interactable3D.PromptData.new(_carry.carried_prompt_message, _carry.carried_prompt_icon))
#
#func exit() -> void:
	#if _carry:
		#UiEvents.dismiss_interaction_prompt_requested.emit()
