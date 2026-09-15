extends Node
class_name LookAtComponent

@export var node: Node3D
@export var target: Node3D

func _physics_process(_delta: float) -> void:
	if not node: return
	
	node.look_at(target.global_position, node.transform.basis.y)
