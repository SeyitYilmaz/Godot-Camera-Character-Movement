extends Camera3D

var sensitivity = 1000

func _unhandled_input(event: InputEvent) ->void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			rotation.y -= event.relative.x / sensitivity
			rotation.x -= event.relative.y / sensitivity
			rotation.x = clamp(rotation.x, deg_to_rad(-90),deg_to_rad(90))

		
