extends Reference

var board
signal processing_end
var no_move_actions = [CONSTS.blocked, CONSTS.portal_blocked]

var in_move = false

#########################
##  Manage animations  ##
#########################


var queue_actions = 0
var queue_effects = 0

func wait_action(object, event = "finished"):
	queue_actions += 1
	object.connect(event, self, "_on_action_done", [], CONNECT_ONESHOT)

func _on_action_done():
	queue_actions -= 1
	try_next_action()

func wait_effect(object, event = "finished"):
	queue_effects += 1
	object.connect(event, self, "_on_effect_done", [], CONNECT_ONESHOT)

func _on_effect_done():
	queue_effects -= 1
	try_end_move()

func try_next_action():
	if queue_actions == 0:
		call_deferred("action_move_robot")

func try_end_move():
	if not in_move and queue_actions == 0 and queue_effects == 0:
		call_deferred("emit_signal", "processing_end")

#####################
## Move the robot  ##
#####################

var previous_locations = {}
var robot
var direction

func move_robot(id_robot, _direction):
	robot = board.robots[str(id_robot)]
	direction = _direction
	in_move = true
	previous_locations = {}
	
	action_move_robot()

func action_move_robot():
	if not robot.destroyed and direction != null:
		# Move datas
		var next_pos = CONSTS.apply_move(robot.line, robot.col, direction)
		var action_result = {action = null, tile_type = null}
		var situation = [robot.line, robot.col, direction]

		# Apply move
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
		
		# Save previous locations
		if not action_result.action in no_move_actions and previous_locations.empty():
			var tile = board.grid[robot.line][robot.col]
			if tile.has_method("robot_exit"):
				tile.robot_exit(robot)
		previous_locations[situation] = true

		# Modify action_result datas
		action_result.to_cell = next_pos
		action_result.action_direction = direction
		if action_result.has("direction"):
			direction = int(action_result.direction)%4

		# Do move effect
		var action_method = "action_" + action_result.action
		if robot.has_method(action_method):
			robot.call(action_method, action_result)
		
		if action_result.action in no_move_actions:
			direction = null
		
		try_next_action()
	else:
		if previous_locations.size() > 1 and not robot.destroyed:
			var tile = board.grid[robot.line][robot.col]
			if tile.has_method("robot_enter"):
				tile.robot_enter(robot)
		in_move = false
		try_end_move()

func _init(_board):
	board = _board
	board.linked_processor = self