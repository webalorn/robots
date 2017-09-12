extends "generic_input_manager.gd"

var active_robot = null

func reset_active_robot():
	if active_robot:
		active_robot.hide_gui()
		active_robot = null

func handle_touch_cell(line, col):
	if game.in_action:
		return
	
	if active_robot and active_robot.destroyed:
		reset_active_robot()
	
	var robot = game.board.robot_on_cell(line, col)
	if not robot and active_robot and int(abs(line - active_robot.line) + abs(col - active_robot.col)) == 1:
		var move = CONSTS.get_move_id_from_dists(line - active_robot.line, col - active_robot.col)
		game.action_move_robot(active_robot, move)
	elif game.board.pos_in_grid(line, col):
		
		var robots = game.board.robots
		if robot:
			if active_robot:
				active_robot.hide_gui()
			if robot != active_robot:
				set_active_robot(robot)
			else:
				active_robot = null
		elif active_robot:
			reset_active_robot()
	else:
		reset_active_robot()

func set_active_robot(robot):
	robot.show_gui("arrows")
	active_robot = robot

func set_active_from_id(robot_id):
	if robot_id and game.board.robots.has(robot_id):
		set_active_robot(game.board.robots[robot_id])

func _init(_game).(_game):
	pass