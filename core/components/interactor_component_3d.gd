extends Node
class_name Interactor3D

signal target_focused(interaction: Interactable3D)
signal target_interacted(interaction: Interactable3D)
signal target_blurred()

@export var _raycast: RayCast3D
@export var _actor: Node3D

var current_interaction: Interactable3D

func initialize(raycast: RayCast3D, actor: Node3D) -> void:
	if _raycast and _actor: return
	_raycast = raycast
	_actor = actor

func _physics_process(_delta: float) -> void:
	if current_interaction and not is_instance_valid(current_interaction):
		_clear_target()
		return
		
	if not _raycast.is_colliding():
		_clear_target()
		return
	
	var collider := _raycast.get_collider()
	
	if collider is Interactable3D:
		if collider.is_enabled:
			if collider == current_interaction: return
			_set_target(collider)
		else:
			_clear_target()

func _set_target(interaction: Interactable3D) -> void:
	if current_interaction:
		_clear_target()
		
	current_interaction = interaction
	current_interaction.focus(_actor)
	target_focused.emit(current_interaction)

func _clear_target() -> void:
	if not current_interaction: return
	
	if is_instance_valid(current_interaction):
		current_interaction.blur(_actor)
	
	target_blurred.emit()
	current_interaction = null
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and current_interaction:
		if not current_interaction.is_enabled: return
		get_viewport().set_input_as_handled()
		current_interaction.interact(_actor)
		target_interacted.emit(current_interaction)
