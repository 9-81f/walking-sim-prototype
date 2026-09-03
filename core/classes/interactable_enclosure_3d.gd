@abstract
extends Node3D
class_name InteractableEnclosure3D

signal opened()
signal closed()

@export_category("Visual Settings")
@export var _mesh_to_tween: Node3D
@export var _default_tween_prop_value: float
@export var _target_tween_prop_value: float
@export var _enable_focus_overlay := true
@export var _focus_material_overlay: StandardMaterial3D = preload("res://assets/materials/color_focus_overlay_02.tres")
@export var _enclosure_tween_duration := 0.5
@export var _lock_jitter_tween_duration := 0.08
@export var is_opened := false

@export_category("Dependencies")
@export var interact: Interactable3D
@export var lock: LockComponent

var _is_tweening := false

func _ready() -> void:
	if interact:
		interact.prompt_message = "Open" if not is_opened else "Close"
		interact.focused.connect(_on_focused)
		interact.interacted.connect(_on_interacted)
		interact.blurred.connect(_on_blurred)
	else:
		push_error("[InteractableEnclosure3D]: Interactable3D not found but required!")
		
func _on_focused(_interactor: Node3D) -> void:
	if _mesh_to_tween and _focus_material_overlay and _enable_focus_overlay:
		_mesh_to_tween.material_overlay = _focus_material_overlay
		
func _on_interacted(_interactor: Node3D) -> void:
	if lock:
		if not lock.attempt_unlock(): 
			_tween_lock_jitter()
			return
	
	_remove_overlay()
	
	if is_opened:
		close()
	else:
		open()
		
func _on_blurred(_interactor: Node3D) -> void :
	_remove_overlay()
	
func open() -> void:
	if is_opened or _is_tweening: return
	is_opened = true
	if interact:
		interact.prompt_message = "Close"
	_tween_mesh(_target_tween_prop_value, Tween.EASE_IN_OUT)
	opened.emit()
	
func close() -> void:
	if not is_opened or _is_tweening: return
	if interact:
		interact.prompt_message = "Open"
	_tween_mesh(_default_tween_prop_value, Tween.EASE_IN_OUT)
	is_opened = false
	closed.emit()

func _remove_overlay() -> void:
	if _mesh_to_tween and _enable_focus_overlay:
		_mesh_to_tween.material_overlay = null
		
func _tween_mesh(_target_value: float, _ease_type: Tween.EaseType) -> void:
	pass
	
func _tween_lock_jitter() -> void:
	pass
	
