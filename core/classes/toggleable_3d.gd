@abstract
extends Node3D
class_name Toggleable3D

@export var _controller: SwitchToggleComponent

func _ready() -> void:
	if _controller:
		_controller.switch_toggled.connect(_on_switch_toggled)
		_controller.switch_locked.connect(_on_switch_locked)
	else:
		push_warning("[Toggleable3D]: No controller assigned!")

@abstract func _on_switch_toggled(toggled: bool) -> void

func _on_switch_locked(_unlocked: bool) -> void: pass
