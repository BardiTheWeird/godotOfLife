extends Node2D

const tile_scene = preload("res://Tile.tscn")

export var tile_width = 50 setget set_tile_width
func set_tile_width(value) -> void:
	tile_width = value
	grid.grid_size = tile_width
	
onready var grid = $Grid
onready var timer = $Timer
onready var tiles_container = $Tiles

# { Vector2 -> Tile }
var map = {}

# move game a step forward
func _on_Timer_timeout():
	# get tile to update state
	var tiles_to_switch_coords := []

	for coords in map.keys():
		var tile : Tile = map[coords]
		var alive_neighbours = get_alive_neighbor_count(coords)
		var new_state := get_updated_state(tile, alive_neighbours)

		if alive_neighbours == 0:
			tile.time_to_live -= 1
			if tile.time_to_live == 0:
				remove_tile(coords)
		else:
			tile.time_to_live = tile.max_time_to_live
			
		if new_state != tile.state:
			tiles_to_switch_coords.append(Vector2(coords))

	# update tile states
	for coords in tiles_to_switch_coords:
		switch_tile_state(coords)

func _unhandled_input(event):
	if not event.is_action_pressed("switch_tile"):
		return
	
	var mouse_pos = get_local_mouse_position()
	var tile_index = mouse_pos / tile_width
	tile_index.x = floor(tile_index.x)
	tile_index.y = floor(tile_index.y)
	switch_tile_state(tile_index)


func add_tile_to_map(coords : Vector2, initial_state=false) -> Tile:
	var tile : Tile = tile_scene.instance()
	map[coords] = tile
	tiles_container.add_child(tile)
	tile.translate(tile_width * coords)
	tile.state = initial_state

	return tile

func remove_tile(coords : Vector2) -> void:
	var tile = map[coords]
	tiles_container.remove_child(tile)
	map.erase(coords)

func add_tile_neighbours(coords : Vector2):
	var neighbour_coords := get_neighbour_coordinates(coords)
	for coords in neighbour_coords:
		if not (coords in map):
			add_tile_to_map(coords)


const left  = Vector2(-1, 0)
const right = Vector2(1, 0)
const down  = Vector2(0, -1)
const up    = Vector2(0, 1)

func get_neighbour_coordinates(coords : Vector2) -> Array:
	var neighbours := []
	
	# orthogonal
	neighbours.append(coords + left)
	neighbours.append(coords + right)
	neighbours.append(coords + up)
	neighbours.append(coords + down)

	# diagonal
	neighbours.append(coords + left + up)
	neighbours.append(coords + left + down)
	neighbours.append(coords + right + up)
	neighbours.append(coords + right + down)

	return neighbours

func switch_tile_state(coords : Vector2):
	var tile : Tile
	if coords in map:
		tile = map[coords]
	else:
		# tile was dead
		tile = add_tile_to_map(coords)
	
	tile.switch_state()
	# if tile is now alive
	if tile.state:
		add_tile_neighbours(coords)

func get_updated_state(tile : Tile, alive_neighbours : int) -> bool:
	if tile.state:
		if alive_neighbours < 2:
			return false
		if alive_neighbours > 3:
			return false
		return true
	elif alive_neighbours == 3:
		return true
	return false

func get_alive_neighbor_count(coords_origin : Vector2) -> int:
	var alive_neighbour_count := 0
	for coords in get_neighbour_coordinates(coords_origin):
		if coords in map:
			alive_neighbour_count += int(map[coords].state)

	return alive_neighbour_count
