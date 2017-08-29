extends "generic_button_tile.gd"

func robot_enter(robot):
	print("enter, pushed = ", pushed)
	if not pushed:
		invert_state()

func _init(a, b, c).(a, b, c):
	pass