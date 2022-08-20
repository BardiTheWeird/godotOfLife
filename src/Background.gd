extends Node2D

export (Color) var background_color : Color

onready var camera = $"../Camera2D"

var grid_size : int = 50

func _draw():
	var size = get_viewport_rect().size * camera.zoom / 2
	var lo = camera.position - size
	var hi = camera.position + size
	lo = grid_size * (floorv(lo / grid_size) - Vector2.ONE)
	hi = grid_size * (floorv(hi / grid_size) + Vector2.ONE)
	# background
	draw_rect(Rect2(camera.position - size, size*2), background_color)

func _on_Camera2D_camera_updated():
	update()

func floorv(v : Vector2):
	return Vector2(
		floor(v.x),
		floor(v.y)
	)
