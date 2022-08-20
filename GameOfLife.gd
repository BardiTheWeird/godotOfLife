extends Node2D

export (Vector2) var map_size = Vector2.ONE * 10
export (PackedScene) var tile_scene

export var tile_width = 50 setget set_tile_width
func set_tile_width(value) -> void:
	tile_width = value
	grid.grid_size = tile_width
	
onready var grid = $Grid
onready var timer = $Timer


# {index_x -> {index_y -> Tile}}
var map = {}

# move game a step forward
func _on_Timer_timeout():
	# get tile to update state
	var tiles_to_switch_coords := []

	for x in map.keys():
		for y in map[x].keys():
			var tile : Tile = map[x][y]
			var alive_neighbours = get_alive_neighbor_count(x, y)
			var new_state := get_updated_state(x, y, tile, alive_neighbours)

			if alive_neighbours == 0:
				tile.time_to_live -= 1
				if tile.time_to_live == 0:
					remove_tile(x, y)
			else:
				tile.time_to_live = tile.max_time_to_live
				
			if new_state != tile.state:
				tiles_to_switch_coords.append(Vector2(x, y))

	# update tile states
	for coords in tiles_to_switch_coords:
		switch_tile_statev(coords)

func _unhandled_input(event):
	if not event.is_action_pressed("switch_tile"):
		return
	
	var mouse_pos = get_local_mouse_position()
	var tile_index = mouse_pos / tile_width
	tile_index.x = floor(tile_index.x)
	tile_index.y = floor(tile_index.y)
	switch_tile_statev(tile_index)


func tile_in_map(x, y) -> bool:
	return x in map and y in map[x]

func tile_in_mapv(coords : Vector2) -> bool:
	return tile_in_map(coords.x, coords.y)

func add_tile_to_map(x, y, initial_state=false) -> Tile:
	if not (x in map):
		map[x] = {}

	var tile : Tile = tile_scene.instance()
	map[x][y] = tile
	add_child(tile)
	tile.translate(Vector2(tile_width * x, tile_width * y))
	tile.state = initial_state

	return tile

func remove_tile(x, y) -> void:
	var tile = map[x][y]
	remove_child(tile)

	map[x].erase(y)
	if map[x].size() == 0:
		map.erase(x)


func add_tile_to_mapv(coords : Vector2, initial_state=false) -> Tile:
	return add_tile_to_map(coords.x, coords.y, initial_state)

func add_tile_neighbours(x, y):
	var neighbour_coords := get_neighbour_coordinates(x, y)
	for coords in neighbour_coords:
		if not tile_in_mapv(coords):
			add_tile_to_mapv(coords)

func get_neighbour_coordinates(x, y) -> Array:
	var left = x - 1
	var right = x + 1
	var down = y - 1
	var up = y + 1

	var neighbours := []
	
	# orthogonal
	neighbours.append(Vector2(left, y))
	neighbours.append(Vector2(right, y))
	neighbours.append(Vector2(x, up))
	neighbours.append(Vector2(x, down))

	# diagonal
	neighbours.append(Vector2(left, up))
	neighbours.append(Vector2(left, down))
	neighbours.append(Vector2(right, up))
	neighbours.append(Vector2(right, down))

	return neighbours

func switch_tile_state(x, y):
	var tile : Tile
	if tile_in_map(x, y):
		tile = map[x][y]
	else:
		# tile was dead
		tile = add_tile_to_map(x, y)
	
	tile.switch_state()
	# if tile is now alive
	if tile.state:
		add_tile_neighbours(x, y)

func switch_tile_statev(tile_indexv):
	switch_tile_state(tile_indexv.x, tile_indexv.y)

func get_updated_state(x, y, tile : Tile, alive_neighbours : int) -> bool:
	if tile.state:
		if alive_neighbours < 2:
			return false
		if alive_neighbours > 3:
			return false
		return true
	elif alive_neighbours == 3:
		return true
	return false

func get_alive_neighbor_count(x : int, y : int) -> int:
	var alive_neighbour_count := 0
	for coords in get_neighbour_coordinates(x, y):
		if tile_in_mapv(coords):
			alive_neighbour_count += int(map[coords.x][coords.y].state)

	return alive_neighbour_count
