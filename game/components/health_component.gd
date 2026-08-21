extends Node
class_name HealthComponent

signal health_changed(current_health: float, current_max_health: float, change_amount: float)
signal hurt(amount: float, source: Node)
signal healed(amount: float)
signal died

@export var is_invincible := false
@export_range(1.0, 9999.0) var max_health := 100.0
var current_health: float :
	set(value):
		var old_health := current_health
		current_health = clampf(value, 0.0, max_health)
		
		var delta := current_health - old_health
		
		if delta != 0.0:
			health_changed.emit(current_health, max_health, delta)
			if is_dead():
				died.emit()
				
func _ready() -> void:
	current_health = max_health - 10

func is_health_full() -> bool:
	return current_health == max_health
	
func is_dead() -> bool:
	return current_health <= 0

func take_damage(amount: float, source: Node = null) -> void:
	if is_invincible or is_dead() or amount <= 0.0: return
	
	current_health -= amount
	hurt.emit(amount, source)
	
func heal(amount: float) -> void:
	if is_invincible or is_dead() or amount <= 0.0: return
	
	current_health += amount
	healed.emit(amount)
	
func get_health_percent() -> float:
	return current_health / max_health if max_health > 0.0 else 0.0
