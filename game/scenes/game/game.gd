extends "res://scenes/base_scene.gd"

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
	yield(processor, "processing_end")
	
	if robot_gui:
		robot.show_gui(robot_gui)
	in_action = false

func _ready():
	game_view = get_node("view")
	board = game_view.get_node("board")
	camera = board.get_node("camera")
	processor = preload("res://engine/processor.gd").new(board)
	input_manager = preload("res://scenes/game/game_input_manager.gd").new(self)
	
	game_view.add_child(input_manager)
	load_level()
	camera.set_pos(Vector2(board.width * board.tile_size, board.height * board.tile_size)/2)
	
	if get_parameter("exit_text"):
		get_node("popups/menu/buttons/button_exit").set_text(get_parameter("exit_text"))

func load_level():
	var save = save_manager.read(get_parameter("level"))
	if save != null:
		board.load_from(save)
	else:
		exit()

func exit():
	global.goto_scene(get_parameter("exit_goto", "main_menu"),
		get_parameter("exit_goto_params", {})
	)

func is_game_input_active():
	if get_node("popups/menu").is_visible():
		return false
	return true

func handle_return_action():
	show_popup("menu")