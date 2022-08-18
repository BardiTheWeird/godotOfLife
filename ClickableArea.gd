extends Area2D

signal pressed

func _input_event(viewport, event, shape_idx):
	if not (event is InputEventMouseButton):
		return
	if not event.button_index == BUTTON_LEFT:
		return
	if not event.pressed:
		return
		
	emit_signal("pressed")
