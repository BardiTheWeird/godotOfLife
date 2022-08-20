extends Camera2D

export var zoom_step := 0.1 setget set_zoom_step
var zoom_stepv : Vector2

func set_zoom_step(value: float) -> void:
	zoom_step = value
	zoom_stepv = Vector2.ONE * zoom_step
	print('zoom_stepv: %s' % zoom_stepv)


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
	elif event.is_action("zoom_in"):
		print('zooming in')
		zoom -= zoom_stepv
	elif event.is_action("zoom_out"):
		print('zooming out')
		zoom += zoom_stepv
