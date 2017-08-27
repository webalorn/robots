extends Control

var CONSTS
var processor
	
func _ready():
	var board = get_node("board")
	board.width = 10
	board.height = 8
	board.add_new_robot(1, 1, 1)
	board.add_new_robot(3, 4, 2)
	
	var wall_class = preload("res://engine/tiles/wall_tile.gd")
	
	board.set_tile_type(2, 2, "wall")
	board.set_tile_type(2, 3, "wall")
	board.set_tile_type(3, 3, "wall")
	board.set_tile_type(4, 1, "wall")
	board.set_tile_type(4, 4, "space")
	
	CONSTS = preload("res://engine/consts.gd")
	processor = preload("res://engine/processor.gd").new(board)
	processor.move_robot(1, CONSTS.DIRS.DOWN)
	yield(processor, "processing_end")
	processor.call_deferred("move_robot", 2, CONSTS.DIRS.DOWN)
	yield(processor, "processing_end")
	processor.call_deferred("move_robot", 1, CONSTS.DIRS.RIGHT)

func scene_init(params):
	print("Game init with params: ", params)