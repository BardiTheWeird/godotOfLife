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
			add_child(tile)
			tile.translate(Vector2(tile_width * x, tile_width * y))
			map[x][y] = tile
			updates_map[x][y] = null
			

func _process(delta):
	switch_tile_state_on_mouse_press()
	
func switch_tile_state_on_mouse_press():
	if not Input.is_action_just_pressed("switch_tile"):
		return
	
	var map_min = Vector2.ZERO
	var map_max = tile_width * map_size
	
	var mouse_pos = get_local_mouse_position()
	var mouse_in_bounds = \
		mouse_pos.x >= map_min.x and mouse_pos.y >= map_min.y and \
		mouse_pos.x < map_max.x and mouse_pos.y < map_max.y
	if not mouse_in_bounds:
		return
	
	var tile_index = mouse_pos / tile_width
	tile_index.x = floor(tile_index.x)
	tile_index.y = floor(tile_index.y)
	map[tile_index.x][tile_index.y].switch_state()

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
