@abstract
extends Control
class_name UIWindow

signal opened()
signal closed()

@export var pause_game_on_open := true

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS

func open() -> void:
	if visible: return
	
	show()
	opened.emit()
	
	if pause_game_on_open:
		get_tree().paused = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	refresh()
	
	# Wait 1 frame so Godot updates layouts before grabbing focus
	await get_tree().process_frame
	var focus_target := _get_initial_focus()
	if focus_target and focus_target.is_inside_tree():
		focus_target.grab_focus()

## Primary API: Call this to close the window
func close() -> void:
	if not visible: 
		return
		
	hide()
	closed.emit()
	
	if pause_game_on_open:
		get_tree().paused = false
		
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

## Primary API: Toggle state
func toggle() -> void:
	if visible:
		close()
	else:
		open()

## Call this whenever data updates while the UI is already open
func refresh() -> void:
	if visible:
		_on_refresh()

# ==========================================
# VIRTUAL METHODS (Override these in child scripts)
# ==========================================

## Override this to write your UI-specific rendering logic
@abstract func _on_refresh() -> void

## Override this to return the Control node that should get initial focus (D-Pad/Keyboard)
@abstract func _get_initial_focus() -> Control
