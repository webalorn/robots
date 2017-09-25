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
var method_to_call

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
		call_deferred(method_to_call)

func try_end_move():
	if not in_move and queue_actions == 0 and queue_effects == 0:
		call_deferred("emit_signal", "processing_end")

#####################
## Move the robot  ##
#####################

var previous_locations = {}
var robot
var direction
var todo_after_move = []

func move_robot(id_robot, _direction):
	robot = board.robots[str(id_robot)]
	direction = _direction
	in_move = true
	previous_locations = {}
	todo_after_move = []
	
	method_to_call = "action_move_robot"
	action_move_robot()

func action_move_robot():
	if not robot.destroyed and not board.coords_on_grid(robot):
		robot.effect_lost_in_space()
		return try_next_action()
	
	if not todo_after_move.empty():
		var action = todo_after_move[0]
		todo_after_move.pop_front()
		if action == "call_on_teleportation_effect":
			if board.coords_on_grid(robot):
				var tile = board.grid[robot.line][robot.col]
				tile.on_teleportation_effect(robot)
		
		try_next_action()
		return
	
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
		if action_result.action == CONSTS.teleport:
			todo_after_move.append("call_on_teleportation_effect")
		
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

#####################
##  Throw portals  ##
#####################

var projectile_end_results = [
	CONSTS.result_blocked,
	CONSTS.result_target_reached,
	CONSTS.result_out_of_grid
]
var projectile
var pos = {}

func throw_portal(robot_id, direction):
	self.direction = direction
	self.robot = board.robots[str(robot_id)]
	pos = {line = robot.line, col = robot.col}
	in_move = true
	
	projectile = preload("res://scenes/game/robots/portal_projectile.tscn").instance()
	projectile.attach(board, robot)
	method_to_call = "get_throw_portal_result"
	
	get_throw_portal_result()

func get_throw_portal_result():
	
	if direction != null:
		
		
		var next_pos = CONSTS.apply_move(pos.line, pos.col, direction)
		var action_result = {"result": CONSTS.result_blocked}
		
		# Apply move
		if not board.pos_in_grid(pos.line, pos.col):
			action_result.result = CONSTS.result_out_of_grid
		elif not board.pos_in_grid(next_pos.line, next_pos.col):
			action_result.result = CONSTS.result_continue
		elif board.robot_on_cell(next_pos.line, next_pos.col):
			action_result.result = CONSTS.result_blocked
		else:
			var next_tile = board.grid[next_pos.line][next_pos.col]
			var enterSide = CONSTS.real_side(CONSTS.invertDir(direction), next_tile.rotation)
			action_result = next_tile.get_projectile_entering_result(enterSide, CONSTS.projectile_portal)
			action_result.side_of_tile = CONSTS.invertDir(direction)
		
		action_result.move_direction = direction
		action_result.from_pos = pos
		action_result.to_pos = next_pos
		if action_result.has("direction"):
			direction = action_result.direction
		
		if not action_result.result in projectile_end_results:
			pos = next_pos
			if action_result.has("teleport_to"):
				pos = action_result.teleport_to
		
		projectile.handle_action(action_result)
		
		if action_result.result in projectile_end_results:
			end_portal_move(action_result)
			direction = null
		
		try_next_action()
	else:
		in_move = false
		try_end_move()

func end_portal_move(result):
	var portal_id = robot.get_portal_id()
	if result.result == CONSTS.result_target_reached:
		var tile = board.grid[result.to_pos.line][result.to_pos.col]
		if tile.portal_id == null:
			tile.portal_id = portal_id
			tile.rotation = result.side_of_tile
		elif tile.portal_id == portal_id:
			tile.portal_id = null

###############
##           ##
###############

func _init(_board):
	board = _board
	board.linked_processor = self