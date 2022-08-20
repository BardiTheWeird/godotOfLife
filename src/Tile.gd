extends Polygon2D
class_name Tile

export (Color) var alive_color : Color
export (Color) var dead_color  : Color
export (int) var max_time_to_live := 5

# false -> dead; true -> alive
var state : bool = false setget set_state
var time_to_live := max_time_to_live

func _ready():
	color = dead_color

func set_state(value : bool) -> void:
	state = value
	var new_color := dead_color
	if state:
		new_color = alive_color
		time_to_live = max_time_to_live

	tween_color(new_color)

func switch_state():
	self.state = !state

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
