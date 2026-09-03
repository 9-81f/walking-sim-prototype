extends Node3D
class_name SwitchToggleComponent

signal switch_locked(unlocked: bool)
signal switch_toggled(toggled: bool)

@export var _one_shot := false
@export var is_toggled := false 

@export_category("Interaction Settings")
@export var interact: Interactable3D
@export var _true_prompt := "Turn off"
@export var _false_prompt := "Turn on"

@export_category("Add-ons")
@export var _lock: LockComponent

var _is_one_shot := false
var is_tweening := false

func _ready() -> void:
	_update_interaction_prompt()
	
	if interact:
		interact.interacted.connect(_on_interacted)
	else:
		push_error("[SwitchToggleComponent]: Interactable3D not found!")
		
func _on_interacted(_interactor: Node3D) -> void:
	if _one_shot and _is_one_shot: return
	
	if _one_shot and not _is_one_shot:
		_is_one_shot = true
	
	if is_tweening: return
	
	if _lock:
		var is_unlocked := _lock.attempt_unlock()
		
		if not is_unlocked: 
			switch_locked.emit(is_unlocked)
			_update_interaction_prompt()
			return
		
	is_toggled = !is_toggled
	
	switch_toggled.emit(is_toggled)
	
	_update_interaction_prompt()
	
func _update_interaction_prompt() -> void:
	if is_toggled:
		interact.prompt_message = _true_prompt
	else:
		interact.prompt_message = _false_prompt
	
	UiEvents.display_interaction_prompt_requested.emit(interact.get_prompt())
