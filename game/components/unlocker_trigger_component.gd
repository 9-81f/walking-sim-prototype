extends Node
class_name UnlockerTriggerComponent
#NOTE: Same here, crude and fast for now to test event triggered unlocking
@export var _trigger_area: TriggerArea3D
@export var _locks: Array[LockComponent]

func _ready() -> void:
	if _trigger_area:
		_trigger_area.observer_entered.connect(_on_observer_entered)
		
func _on_observer_entered() -> void:
	if _locks.is_empty(): return
	
	for lock in _locks:
		if not lock._is_unlocked or lock._is_permanent_locked:
			lock._is_permanent_locked = false
			lock._is_unlocked = true
