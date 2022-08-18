extends Node2D

export (Vector2) var map_size = Vector2.ONE * 10
export (PackedScene) var tile_scene
export var tile_width = 50

onready var timer = $Timer

var map = []
var updates_map = []

func _ready():
	# init map
	map.resize(map_size.x)
	updates_map.resize(map_size.x)
	for x in range(map_size.x):
		map[x] = []
		map[x].resize(map_size.y)
		updates_map[x] = []
		updates_map[x].resize(map_size.y)
		for y in range(map_size.y):
			var tile : Tile = tile_scene.instance()
			tile.set_dead()
			tile.translate(Vector2(tile_width * x, tile_width * y))
			map[x][y] = tile
			updates_map[x][y] = null
			add_child(tile)

# move game a step forward
func _on_Timer_timeout():
	# fill updates
	for x in range(map_size.x):
		for y in range(map_size.y):
			var tile : Tile = map[x][y]
			var alive_neighbours = get_alive_neighbor_count(x, y)
			updates_map[x][y] = get_updated_state(tile, alive_neighbours)

	# update
	for x in range(map_size.x):
		for y in range(map_size.y):
			if updates_map[x][y] == null:
				continue
			if updates_map[x][y]:
				map[x][y].set_alive()
			else:
				map[x][y].set_dead()

			
			
func get_alive_neighbor_count(x : int, y : int) -> int:
	var left = x - 1
	var left_exists = left >= 0 
	var right = x + 1
	var right_exists = right < map_size.x
	var down = y - 1
	var down_exists = down >= 0
	var up = y + 1
	var up_exists = up < map_size.y
	
	var alive_neighours = 0
	alive_neighours += int(left_exists  and map[left][y].alive)
	alive_neighours += int(right_exists and map[right][y].alive)
	alive_neighours += int(up_exists    and map[x][up].alive)
	alive_neighours += int(down_exists  and map[x][down].alive)

	alive_neighours += int(up_exists    and left_exists  and map[left][up].alive)
	alive_neighours += int(down_exists  and left_exists  and map[left][down].alive)
	alive_neighours += int(up_exists    and right_exists and map[right][up].alive)
	alive_neighours += int(down_exists  and right_exists and map[right][down].alive)

	return alive_neighours

func get_updated_state(tile : Tile, alive_neighbours : int):
	if tile.alive:
		if alive_neighbours < 2:
			return false
		if alive_neighbours > 3:
			return false
		return null
	elif alive_neighbours == 3:
		return true
	return null

func _on_StartButton_pressed():
	timer.start()

func _on_StopButton_pressed():
	timer.stop()
