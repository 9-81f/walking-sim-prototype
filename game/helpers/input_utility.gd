class_name InputUtility

static func get_input_key_as_text(action_name: StringName) -> String:
	var events := InputMap.action_get_events(action_name);
	for event in events:
		if event is InputEventKey:
			return event.as_text_physical_keycode()
	return ""
