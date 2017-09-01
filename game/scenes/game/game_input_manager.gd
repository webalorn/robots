extends "generic_input_manager.gd"

var active_robot = null

func reset_active_robot():
	active_robot.hide_gui()
	active_robot = null

func handle_touch_cell(line, col):
	if game.in_action:
		return
	
	if active_robot and int(abs(line - active_robot.line) + abs(col - active_robot.col)) == 1:
		var move = CONSTS.get_move_id_from_dists(line - active_robot.line, col - active_robot.col)
		game.action_move_robot(active_robot, move)
	elif game.board.pos_in_grid(line, col):
		
		var robots = game.board.robots
		var robot = game.board.robot_on_cell(line, col)
		if robot:
			if active_robot:
				active_robot.hide_gui()
			if robot != active_robot:
				robot.show_gui("arrows")
				active_robot = robot
		elif active_robot:
			reset_active_robot()
	else:
		reset_active_robot()

func _init(_game).(_game):
	pass