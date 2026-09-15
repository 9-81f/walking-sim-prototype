extends Node3D

@export var target: Node3D
@onready var look_at_modifier_3d: LookAtModifier3D = $Armature/Skeleton3D/LookAtModifier3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if animation_player:
		animation_player.play(&"Armature|Idle")
	if target:
		look_at_modifier_3d.target_node = look_at_modifier_3d.get_path_to(target)
