extends Polygon2D
class_name Tile

export (Color) var alive_color
export (Color) var dead_color

onready var tween : Tween = $Tween

var alive : bool = false

func _ready():
	set_dead()

func set_dead():
	alive = false
	tween.interpolate_property(self, "color",
		color, dead_color, 0.2, 
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()

func set_alive():
	alive = true
	tween.interpolate_property(self, "color",
		color, alive_color, 0.2, 
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()

func switch_state():
	if alive:
		set_dead()
	else:
		set_alive()
