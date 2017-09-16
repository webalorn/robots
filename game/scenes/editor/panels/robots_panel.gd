extends "editor_panel.gd"

var robot_list = {}
var selected = null

func action_on_cell(line, col):
	if selected:
		var on_cell = board.robot_on_cell(line, col)
		if on_cell:
			if on_cell.robot_id == selected:
				remove_robot(selected)
				editor.add_step()
			else:
				editor.notify("ALREADY_ROBOT_ON_CELL")
		else:
			if board.robots.has(selected):
				remove_robot(selected)
			add_robot(selected, line, col)
			editor.add_step()

func on_show_panel():
	if robot_list.empty():
		var ROBOT_CLASS = preload("res://engine/robot.gd")
		for robot_name in ROBOT_CLASS.existants_ids:
			var robot_item = preload("elements/editor_robot.tscn").instance()
			robot_item.name = robot_name
			get_node("content/scroll/robots").add_child(robot_item)
			robot_list[robot_item.name] = robot_item
			robot_item.panel = self
			robot_item.set_on_board(board.robots.has(robot_item.name))
	else:
		for robot_name in robot_list:
			robot_list[robot_name].set_on_board(board.robots.has(robot_name))

func on_hide_panel():
	pass

func remove_robot(name):
	if board.robots.has(name):
		board.remove_robot(name)
		robot_list[name].set_on_board(false)

func add_robot(name, line, col):
	if not board.robots.has(name):
		board.add_new_robot(line, col, name)
		robot_list[name].set_on_board(true)

func select_robot(name):
	if selected:
		robot_list[selected].set_selected(false)
	selected = name
	robot_list[name].set_selected(true)