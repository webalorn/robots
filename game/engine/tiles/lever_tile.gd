extends "generic_button_tile.gd"

func robot_enter(robot):
	if not pushed:
		invert_state()

func _init(a, b, c).(a, b, c):
	pass