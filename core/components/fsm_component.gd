extends Node
class_name FiniteStateMachineComponent

@export var default_state: StringName = &"IdleState"

var _states: Dictionary[StringName, State] = {}
var current_state: State
var previous_state: State

func transition_state(to_state_name: StringName, prev_state: State = current_state) -> void:
	if not _states.has(to_state_name):
		push_error("[FSMComponent]: Target state '%s' doesn't exist!" % to_state_name)
		return
	
	previous_state = prev_state
	_state_rotation(to_state_name)

func _ready() -> void:
	if get_child_count() == 0:
		push_error("[FSMComponent]: Child state nodes required!")
		return

	for child in get_children():
		if child is State:
			_states[child.name] = child
			child.state_changed.connect(_on_state_changed)
	
	if default_state and _states.has(default_state):
		_state_rotation(default_state)
	else:
		push_error("[FSMComponent]: Default state '%s' not found in child nodes!" % default_state)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _state_rotation(new_state_name: StringName) -> void:
	if current_state:
		current_state.exit()
		
	current_state = _states[new_state_name]
	current_state.enter()

func _on_state_changed(to_state_name: StringName, prev_state: State = null) -> void:
	transition_state(to_state_name, prev_state)
