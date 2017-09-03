extends Control

export(String) var name
const ROBOT_CLASS = preload("res://engine/robot.gd")
var panel

func _ready():
	get_node("name").set_text(name)
	get_node("robot").set_texture(ROBOT_CLASS.get_robot_icon(name))
	set_selected(false)

func set_on_board(is_on_board):
	get_node("delete").set_hidden(not is_on_board)

func set_selected(value):
	get_node("background").set_hidden(not value)

func _on_press_select():
	panel.select_robot(name)

func _on_press_delete():
	panel.remove_robot(name)