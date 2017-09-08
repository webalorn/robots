extends "res://scenes/base_scene.gd"

var processor
var board
var camera
var input_manager
var changes_manager
var game_view
var in_action = false

func action_move_robot(robot, move):
	in_action = true
	var cam_parent = camera.get_parent()
	var robot_gui = robot.get_active_gui()
	robot.hide_gui()
	
	processor.move_robot(robot.robot_id, move)
	yield(processor, "processing_end")
	
	changes_manager.add_step(board.save())
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
	changes_manager = preload("res://engine/changes_manager.gd").new(board.save())
	
	if get_parameter("exit_text"):
		get_node("popups/menu/buttons/button_exit").set_text(get_parameter("exit_text"))

func load_level():
	var save = save_manager.read(get_parameter("level"))
	if save != null:
		board.load_from(save)
	else:
		board.load_from(save_manager.read("res://data/levels/chapter_1/1.dat"))

func exit():
	global.goto_scene(get_parameter("exit_goto", "main_menu"),
		get_parameter("exit_goto_params", {})
	)

func _on_restart():
	input_manager.reset_active_robot()
	load_level()

func _on_cancel_move():
	var active_robot = input_manager.active_robot
	if active_robot:
		active_robot = active_robot.robot_id
		
	changes_manager.revert_last_change()
	board.load_from(changes_manager.get_state())
	
	input_manager.set_active_from_id(active_robot)

func is_game_input_active():
	if get_node("popups/menu").is_visible():
		return false
	return true

func handle_return_action():
	show_popup("menu")