extends "generic_input_manager.gd"

var active_robot = null
var portal_action = false
var portal_button

func reset_active_robot():
	if active_robot:
		active_robot.hide_gui()
		active_robot = null
	portal_button.set_hidden(true)

func handle_touch_cell(line, col):
	if game.in_action:
		return
	
	if active_robot and active_robot.destroyed:
		reset_active_robot()
	
	var robot = game.board.robot_on_cell(line, col)
	if not robot and active_robot and int(abs(line - active_robot.line) + abs(col - active_robot.col)) == 1:
		var move = CONSTS.get_move_id_from_dists(line - active_robot.line, col - active_robot.col)
		if not portal_action:
			game.action_move_robot(active_robot, move)
		else:
			game.action_throw_portal(active_robot, move)
	elif game.board.pos_in_grid(line, col):
		portal_action = false
		var robots = game.board.robots
		if robot:
			if active_robot:
				active_robot.hide_gui()
			if robot != active_robot:
				set_active_robot(robot)
			else:
				reset_active_robot()
		elif active_robot:
			reset_active_robot()
	else:
		portal_action = false
		reset_active_robot()

func set_active_robot(robot):
	active_robot = robot
	portal_action = false
	show_robot_gui()

func show_robot_gui():
	if portal_action:
		active_robot.show_gui("portal_arrows")
	else:
		active_robot.show_gui("arrows")
	portal_button.set_hidden(active_robot.get_portal_id() == null)

func toogle_action_portal():
	if not game.in_action:
		portal_action = not portal_action
		show_robot_gui()

func set_active_from_id(robot_id):
	if robot_id and game.board.robots.has(robot_id):
		set_active_robot(game.board.robots[robot_id])

func _init(_game).(_game):
	portal_button = game.get_node("gui/portal_button")
	portal_button.connect("pressed", self, "toogle_action_portal")
	portal_button.set_hidden(true)