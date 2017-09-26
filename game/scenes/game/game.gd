extends "res://scenes/base_scene.gd"

var board
var camera
var robots_bar
var game_view

var processor
var input_manager
var changes_manager
var in_action = false

###############
##  Actions  ##
###############

var robot_gui
func before_action(robot):
	in_action = true
	robot_gui = robot.get_active_gui()
	robot.hide_gui()
	board.emit_signal("robot_move_begin_event", robot.robot_id)

func after_action(robot):
	changes_manager.add_step(board.save())
	if robot_gui:
		robot.show_gui(robot_gui)
	in_action = false
	
	input_manager.show_robot_gui()
	if board.is_level_done():
		set_level_to_done()
	
	board.emit_signal("robot_move_end_event", robot.robot_id)

func action_move_robot(robot, move):
	before_action(robot)
	processor.move_robot(robot.robot_id, move)
	yield(processor, "processing_end")
	after_action(robot)

func action_throw_portal(robot, direction):
	before_action(robot)
	processor.throw_portal(robot.robot_id, direction)
	yield(processor, "processing_end")
	after_action(robot)

###############
##           ##
###############

func _ready():
	game_view = get_node("view")
	board = game_view.get_node("board")
	robots_bar = get_node("gui/robots_bar")
	camera = board.get_node("camera")
	processor = preload("res://engine/processor.gd").new(board)
	input_manager = preload("res://scenes/game/game_input_manager.gd").new(self)
	
	game_view.add_child(input_manager)
	load_level()
	camera.set_pos(Vector2(board.width * board.tile_size, board.height * board.tile_size)/2)
	changes_manager = preload("res://engine/changes_manager.gd").new(board.save())
	display_gui_actual_state()
	
	if get_parameter("exit_text"):
		get_node("popups/menu/buttons/button_exit").set_text(get_parameter("exit_text"))

func load_level():
	var save = save_manager.read(get_parameter("level"))
	if save != null:
		board.load_from(save)
	elif OS.is_debug_build():
		# board.load_from(save_manager.read("res://data/levels/chapter_1/1.dat"))
		board.load_from(save_manager.read("user://editor/tests.dat"))
	else:
		exit()

func exit():
	global.goto_scene(get_parameter("exit_goto", "main_menu"),
		get_parameter("exit_goto_params", {})
	)

func set_level_to_done():
	input_manager.reset_active_robot()
	var window = show_popup("end_level")
	var next_level_button = window.get_node("buttons/next_level")
	if get_parameter("from_editor") or not level_manager.get_next_level(get_parameter("level")):
		next_level_button.set_hidden(true)
	else:
		next_level_button.set_hidden(false)

func _on_next_level():
	var next_path = level_manager.get_next_level(get_parameter("level"))
	scene_params.level = next_path
	global.goto_scene("game", scene_params)

###########
##  GUI  ##
###########

func display_gui_actual_state():
	if robots_bar.get_children().empty():
		var ids = board.ROBOT_CLASS.existants_ids
		for robot_name in ids:
			if not board.robots.has(robot_name):
				continue
			var item = preload("gui/robot_icon.tscn").instance()
			item.set_robot(board, robot_name)
			item.add_to_group("gui_buttons")
			robots_bar.add_child(item)
			item.connect("selected", input_manager, "input_set_active_from_id")
	
	for item in robots_bar.get_children():
		item.display_state()

##################
## Manage input ##
##################

func _on_restart():
	input_manager.reset_active_robot()
	load_level()
	changes_manager.reset_to(board.save())
	display_gui_actual_state()

func _on_cancel_move():
	if self.in_action:
		return
	var active_robot = input_manager.active_robot
	if active_robot:
		active_robot = active_robot.robot_id
		
	changes_manager.revert_last_change()
	board.load_from(changes_manager.get_state())
	
	input_manager.set_active_from_id(active_robot)
	display_gui_actual_state()

func is_game_input_active():
	for p in get_node("popups").get_children():
		if p.is_visible():
			return false
	for node in get_tree().get_nodes_in_group("gui_buttons"):
		if node.is_pressed():
			return false
	return true

func handle_return_action():
	show_popup("menu")