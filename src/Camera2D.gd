extends Camera2D

signal camera_updated

export var zoom_step := 0.1 setget set_zoom_step
var zoom_stepv : Vector2
func set_zoom_step(value: float) -> void:
	zoom_step = value
	zoom_stepv = Vector2.ONE * zoom_step

var mouse_start_pos
var screen_start_position

var dragging = false

func _ready():
	self.zoom_step = zoom_step

func _input(event):
	if event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.position
			screen_start_position = position
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		position = zoom * (mouse_start_pos - event.position) + screen_start_position
		emit_signal("camera_updated")
	elif event.is_action("zoom_in"):
		zoom -= zoom_stepv
		emit_signal("camera_updated")
	elif event.is_action("zoom_out"):
		zoom += zoom_stepv
		emit_signal("camera_updated")
