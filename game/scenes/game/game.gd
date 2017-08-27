extends Control

func _ready():
	var board = get_node("board")
	board.width = 10
	board.height = 8
	board.add_new_robot(1, 1, 1)
	board.add_new_robot(3, 5, 2)
	
	var wall_class = load("res://engine/tiles/wall_tile.gd")
	
	board.set_tile_type(2, 2, "wall")
	board.set_tile_type(2, 3, "wall")
	board.set_tile_type(3, 3, "wall")
	board.set_tile_type(4, 4, "space")

func scene_init(params):
	print("Game init with params: ", params)