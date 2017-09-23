extends Control

var robot_name
var board

signal selected(id)

func display_state():
	var robot = board.robots[robot_name]
	var cross = get_node("item/icon/cross")
	var set_visible = robot.destroyed
	if set_visible:
		if not cross.is_visible():
			cross.set_hidden(false)
			cross.set_opacity(0)
			get_node("anims").play("destroyed")
	else:
		cross.set_hidden(true)
	
	var on_end = false
	if not robot.destroyed:
		var tile = board.grid[robot.line][robot.col]
		if tile.has_method("end_activated_by") and tile.end_activated_by(robot_name):
			on_end = true
	print(on_end)
	get_node("item/on_end_tile").set_hidden(not on_end)

func _on_robot_dead(id):
	if id == robot_name:
		display_state()

func _on_robot_move(id):
	if id == robot_name:
		display_state()

func _on_robot_move_starts(id):
	if id == robot_name:
		get_node("item/on_end_tile").set_hidden(true)

func set_robot(_board, _name):
	robot_name = _name
	board = _board
	board.connect("robot_dead_event", self, "_on_robot_dead")
	board.connect("robot_move_begin_event", self, "_on_robot_move_starts")
	board.connect("robot_move_end_event", self, "_on_robot_move")
	var robot = board.robots[robot_name]
	get_node("item/icon").set_normal_texture(robot.get_robot_icon(robot.robot_id))

func _on_icon_pressed():
	emit_signal("selected", robot_name)