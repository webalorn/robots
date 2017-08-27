extends Reference

var board
var CONSTS
signal processing_end
var previous_locations = {} # TODO: use this

func move_robot(id_robot, direction):
	var robot = board.robots[id_robot]
	print("move_robot")
	
	if robot.is_connected("signal_action_end", self, "move_robot"):
		robot.disconnect("signal_action_end", self, "move_robot")
	
	if not robot.destroyed and direction != null:
		print("ok")
		var next_pos = CONSTS.apply_move(robot.line, robot.col, direction)
	
		var action_result = {action = null, tile_type = null}
		if not board.pos_in_grid(next_pos.line, next_pos.col):
			action_result.action = CONSTS.lost_in_space
		elif board.robot_on_cell(next_pos.line, next_pos.col):
			action_result.action = CONSTS.blocked
		else:
			var next_tile = board.grid[next_pos.line][next_pos.col]
			action_result = next_tile.get_entering_result(CONSTS.invertDir(direction))
			action_result.tile_type = next_tile.tile_type
		
		action_result.to_cell = next_pos
		if action_result.has("direction"):
			direction = int(action_result.direction)%4
		
		print(action_result)
		
		if not action_result.action in [CONSTS.blocked]:
			robot.connect("signal_action_end", self, "move_robot", [id_robot, direction])
			robot.call("action_" + action_result.action, action_result)
		else:
			move_robot(id_robot, null)
	else:
		print("fini")
		previous_locations = {}
		emit_signal("processing_end")

func _init(_board):
	board = _board
	CONSTS = preload("res://engine/consts.gd")