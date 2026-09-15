extends Node3D
class_name TweenWalkOffComponent3D

#NOTE: A really crude implementation of triggering animation. I just need this to be done and working fast for now.
@export var _trigger_area: TriggerArea3D
@export var _tween_target: Node3D

func _ready() -> void:
	if _tween_target:
		_tween_target.hide()
		
	if _trigger_area:
		_trigger_area.observer_entered.connect(_on_observer_entered)
		_trigger_area.observer_exited.connect(_on_observer_exited)
		
func _on_observer_entered() -> void:
	if not _tween_target: return

	_tween_target.show()
	
	var anim_player := _tween_target.get_node_or_null("AnimationPlayer") as AnimationPlayer
	if anim_player:
		anim_player.play(&"Armature|Idle")
		
func _on_observer_exited() -> void:
	if not _tween_target: return

	var tween := _tween_target.create_tween()
	
	var anim_player := _tween_target.get_node_or_null("AnimationPlayer") as AnimationPlayer
	if anim_player:
		anim_player.play(&"Armature|Walk")
		anim_player.speed_scale = 2.0
	
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(_tween_target, "rotation_degrees:y", _tween_target.rotation_degrees.y + -90.0, 0.35)
	tween.tween_property(_tween_target, "global_position:z", _tween_target.global_position.z - 3.0, 0.8)
	
	await tween.finished
	
	anim_player.speed_scale = 1.0
	_tween_target.queue_free()
	_tween_target = null
