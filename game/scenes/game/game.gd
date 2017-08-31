extends Control

var processor
var board
var camera
var input_manager
var game_view
var in_action = false

func action_move_robot(robot, move):
	in_action = true
	var cam_parent = camera.get_parent()
	var robot_gui = robot.get_active_gui()
	robot.hide_gui()
	
	processor.move_robot(robot.robot_id, move)
	print("move deb")
	yield(processor, "processing_end")
	print("fin")
	
	if robot_gui:
		robot.show_gui(robot_gui)
	in_action = false
	

func _ready():
	game_view = get_node("view")
	board = game_view.get_node("board")
	camera = game_view.get_node("camera")
	processor = preload("res://engine/processor.gd").new(board)
	input_manager = preload("res://scenes/game/game_input_manager.gd").new(self)
	
	camera.change_parent(board)
	game_view.add_child(input_manager)
	tmp_gen_board()
	camera.set_pos(Vector2(board.width * board.tile_size, board.height * board.tile_size)/2)

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

func scene_init(params):
	print("Game init with params: ", params)

func exit():
	global.goto_scene("main_menu")

func is_game_input_active():
	if get_node("menu").is_visible():
		return false
	return true

func _notification(what):
	if OS.get_name() == "Android" and global.is_android_return(what):
		var menu_popup = get_node("menu")
		if menu_popup.is_visible():
			menu_popup.hide()
		else:
			get_node("menu_background").popup()
			menu_popup.call_deferred("popup")
		