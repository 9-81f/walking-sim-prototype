@abstract
extends Node
class_name State

signal state_changed(to_state_name: StringName, previous_state: State)

func set_state(to_state_name: StringName, prev_state: State) -> void:
	state_changed.emit(to_state_name, prev_state)

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(_delta: float) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	pass
