extends Area3D
class_name TriggerArea3D

signal observer_entered
signal observer_exited

@export var one_shot := false
var _has_triggered := false

func _ready() -> void:
	set_collision_layer_value(11, true)
	set_collision_mask_value(1, false)
	area_entered.connect(_on_trigger_observer_entered)
	area_exited.connect(_on_trigger_observer_exited)
	
func _on_trigger_observer_entered(_area: Area3D) -> void:
	if one_shot and _has_triggered: return
	_has_triggered = true
	observer_entered.emit()
	
func _on_trigger_observer_exited(_area: Area3D) -> void:
	if one_shot and _has_triggered: return
	observer_exited.emit()
