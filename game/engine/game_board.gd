extends Node2D

var height = 0 setget resize_height
var width = 0 setget resize_width
var grid = []
var robots = Dictionary()
export var tile_size = 30 setget resize_tiles
var mode = "game"

const TILE_CLASS = preload("res://engine/tiles/floor_tile.gd")
const ROBOT_CLASS = preload("res://engine/robot.gd")

func get_new_tile(line, col, type = "floor"):
	var tile = TILE_CLASS.createTile(type, line, col)
	get_node("tiles").add_child(tile)
	return tile

func set_tile_type(line, col, type = "floor"):
	var old = grid[line][col]
	if old.tile_type == type:
		return
	old.close_properties()
	var new_tile = get_new_tile(line, col, type)
	new_tile.rotation = old.rotation
	grid[line][col] = new_tile
	old.queue_free()
	return new_tile

func add_new_robot(line, col, id_robot):
	var robot = ROBOT_CLASS.new(line, col, str(id_robot))
	get_node("robots").add_child(robot)
	robots[str(id_robot)] = robot

func get_robot(id_robot):
	if robots.has(id_robot):
		return robots[id_robot]

func remove_robot(id_robot):
	robots[id_robot].queue_free()
	robots.erase(id_robot)

func robot_on_cell(line, col):
	for id in robots:
		if robots[id].line == line and robots[id].col == col and not robots[id].destroyed:
			return robots[id]
	return null

func resize_tiles(value):
	tile_size = value
	for line in grid:
		for tile in line:
			tile.set_sprite_pos_size()
	for robot_id in robots:
		robots[robot_id].set_sprite_pos_size()

func resize_height(newHeight):
	for line in range(newHeight, height):
		for tile in grid[-1]:
			tile.queue_free()
		grid.pop_back()
	for line in range(height, newHeight):
		grid.push_back([])
		for col in range(width):
			grid[-1].push_back(get_new_tile(line, col))
	
	height = newHeight
	
func resize_width(newWidth):
	for line in range(height):
		for col in range(newWidth, width):
			grid[line][-1].queue_free()
			grid[line].pop_back()
		for col in range(width, newWidth):
			grid[line].push_back(get_new_tile(line, col))
	
	width = newWidth
	
func pos_in_grid(line, col):
	if line < 0 or col < 0 or line >= height or col >= width:
		return false
	return true

func get_board_size():
	return Vector2(width * tile_size, height * tile_size)

func clear():
	resize_width(0)
	resize_height(0)
	for id in robots:
		robots[id].queue_free()
	robots = []

func save():
	var s = {
		robots = {},
		grid = [],
		width = self.width,
		height = self.height,
		save_version = save_manager.SAVE_VERSION
	}
	for id in robots:
		s.robots[id] = robots[id].save()
	for line in grid:
		s.grid.push_back([])
		for tile in line:
			s.grid[-1].push_back(tile.save())
	return s

func load_from(s):
	self.clear()
	height = s.height
	width = s.width
	grid = []
	robots = s.robots
	for line in range(height):
		grid.push_back([])
		for col in range(width):
			grid[line].push_back([])
			grid[line][col] = TILE_CLASS.load_from(s.grid[line][col])
			get_node("tiles").add_child(grid[line][col])
	for line in range(height):
		for col in range(width):
			grid[line][col].load_refs_from(s.grid[line][col])
	for id in robots:
		robots[id] = ROBOT_CLASS.load_from(robots[id])
		get_node("robots").add_child(robots[id])