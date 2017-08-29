extends Reference

var board
signal processing_end
var previous_locations = {}
var no_move_actions = [CONSTS.blocked, CONSTS.portal_blocked]

func move_robot(id_robot, direction):
	var robot = board.robots[str(id_robot)]

	if robot.is_connected("signal_action_end", self, "move_robot"):
		robot.disconnect("signal_action_end", self, "move_robot")

	if not robot.destroyed and direction != null:
		var next_pos = CONSTS.apply_move(robot.line, robot.col, direction)

		var action_result = {action = null, tile_type = null}
		var situation = [robot.line, robot.col, direction]

		if previous_locations.has(situation):
			action_result.action = CONSTS.destroyed
		elif not board.pos_in_grid(next_pos.line, next_pos.col):
			action_result.action = CONSTS.lost_in_space
		elif board.robot_on_cell(next_pos.line, next_pos.col):
			action_result.action = CONSTS.blocked
		else:
			var next_tile = board.grid[next_pos.line][next_pos.col]
			var enterSide = CONSTS.real_side(CONSTS.invertDir(direction), next_tile.rotation)
			action_result = next_tile.get_entering_result(enterSide)
			action_result.tile_type = next_tile.tile_type
		
		if not action_result in no_move_actions and previous_locations.empty():
			var tile = board.grid[robot.line][robot.col]
			if tile.has_method("robot_exit"):
				tile.robot_exit(robot)
		
		previous_locations[situation] = true

		action_result.to_cell = next_pos
		action_result.action_direction = direction
		if action_result.has("direction"):
			direction = int(action_result.direction)%4

		if not action_result.action in no_move_actions:
			robot.connect("signal_action_end", self, "move_robot", [id_robot, direction])
			robot.call("action_" + action_result.action, action_result)
		else:
			move_robot(id_robot, null)
	else:
		if previous_locations.size() > 1:
			var tile = board.grid[robot.line][robot.col]
			if tile.has_method("robot_enter"):
				tile.robot_enter(robot)
		previous_locations = {}
		emit_signal("processing_end")

func _init(_board):
	board = _board