extends Node2D

export (Color) var line_color : Color
export (float) var line_width := 1.0

onready var camera = $"../Camera2D"

var grid_size : int = 50

func _draw():
	var size = get_viewport_rect().size * camera.zoom / 2
	var lo = camera.position - size
	var hi = camera.position + size
	lo = grid_size * (floorv(lo / grid_size) - Vector2.ONE)
	hi = grid_size * (floorv(hi / grid_size) + Vector2.ONE)
	# vertical lines
	for x in range(int(lo.x), int(hi.x), grid_size):
		draw_line(
			Vector2(x, lo.y),
			Vector2(x, hi.y),
			line_color,
			line_width
		)
	# horizontal lines
	for y in range(int(lo.y), int(hi.y), grid_size):
		draw_line(
			Vector2(lo.x, y),
			Vector2(hi.x, y),
			line_color,
			line_width
		)

func _on_Camera2D_camera_updated():
	update()

func floorv(v : Vector2):
	return Vector2(
		floor(v.x),
		floor(v.y)
	)
