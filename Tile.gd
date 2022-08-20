extends Polygon2D
class_name Tile

export (Color) var alive_color
export (Color) var dead_color

var alive : bool = false

func _ready():
	set_dead()

func set_dead():
	alive = false
	tween_color(dead_color)

func set_alive():
	alive = true
	tween_color(alive_color)

func switch_state():
	if alive:
		set_dead()
	else:
		set_alive()

func tween_color(new_color : Color):
	var tween := create_tween()\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "color", new_color, 0.2)
	
	var rotation_tween := create_tween()\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN)
	# rotation_tween.tween_property(self, "rotation", deg2rad(-10), 0.05)
	# rotation_tween.tween_property(self, "rotation", deg2rad(5), 0.05)
	# rotation_tween.tween_property(self, "rotation", deg2rad(0), 0.05)
