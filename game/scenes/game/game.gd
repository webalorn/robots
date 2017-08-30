extends Control

var processor
var board
var camera
var input_manager

func _ready():
	board = get_node("view/board")
	camera = get_node("view/camera")
	processor = preload("res://engine/processor.gd").new(board)
	input_manager = preload("res://scenes/game/game_input_manager.gd").new(self)
	
	#camera.change_parent(board)
	add_child(input_manager)
	
	tmp_gen_board();

func tmp_gen_board():
	
	board.width = 10
	board.height = 8
	board.add_new_robot(1, 1, 1)
	board.add_new_robot(3, 4, 2)
	
	var wall_class = preload("res://engine/tiles/wall_tile.gd")
	
	board.set_tile_type(1, 3, "wall")
	board.set_tile_type(2, 3, "wall")
	board.set_tile_type(3, 3, "wall")
	board.set_tile_type(4, 1, "wall")
	board.set_tile_type(4, 4, "space")
	
	var b1 = board.set_tile_type(3, 1, "push_button")
	
	var p1 = board.set_tile_type(6, 2, "portal")
	var p2 = board.set_tile_type (1, 2, "portal")
	p2.linked_to = p1
	p2.rotation = CONSTS.DIRS.DOWN;
	p1.set_is_active(false)
	b1.add_target(p1)
	
	save_manager.save_to("user://saves/first_save.dat", board.save())
	board.load_from(save_manager.read("user://saves/first_save.dat"))
	
	
	processor.move_robot(1, CONSTS.DIRS.DOWN)
	#camera.change_parent(board.robots['1'])
	yield(processor, "processing_end")
	
	processor.call_deferred("move_robot", 2, CONSTS.DIRS.DOWN)
	yield(processor, "processing_end")
	
	processor.call_deferred("move_robot", 1, CONSTS.DIRS.RIGHT)
	yield(processor, "processing_end")
	
	processor.call_deferred("move_robot", 1, CONSTS.DIRS.DOWN)
	yield(processor, "processing_end")

func scene_init(params):
	print("Game init with params: ", params)

func exit():
	global.goto_scene("main_menu")