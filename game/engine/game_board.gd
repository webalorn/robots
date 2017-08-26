extends Node2D

var height = 0 setget resize_height
var width = 0 setget resize_width
var grid = []
export var tilesSize = 30 setget resize_tiles
var mode = "game"
var active = false

const TILE_CLASS = preload("res://engine/tile.gd")

func get_new_tile(line, col):
	var tile = TILE_CLASS.new(line, col, tilesSize)
	add_child(tile)
	return tile

func resize_tiles(value):
	tilesSize = value
	for line in grid:
		for tile in line:
			tile.tileSize = tilesSize

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

func _ready():
	resize_height(5)
	resize_width(2)
	grid[1][1].rotation = 1

func _init():
	pass