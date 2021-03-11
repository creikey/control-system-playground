extends TextEdit


func _gui_input(event):
	if Input.is_key_pressed(KEY_CONTROL):
		var zoom_factor: int = 0
		if event.is_action_pressed("zoom_in"):
			zoom_factor = 1
		elif event.is_action_pressed("zoom_out"):
			zoom_factor = -1
		var font: DynamicFont = get("custom_fonts/font")
		font.size += zoom_factor
