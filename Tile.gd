extends Polygon2D
class_name Tile

export (Color) var alive_color
export (Color) var dead_color

var alive : bool = false

func set_dead():
	alive = false
	color = dead_color

func set_alive():
	alive = true
	color = alive_color

func _on_ClickableArea_pressed():
	if alive:
		set_dead()
	else:
		set_alive()
