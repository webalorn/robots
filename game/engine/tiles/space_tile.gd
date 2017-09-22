extends "../tile.gd"

var active = true setget set_active

func _init(a, b, c).(a, b, c):
	pass

func is_safe_for_robot():
	return not active

func is_robot_teleportation_possible():
	return true

func on_teleportation_effect(robot):
	if active:
		robot.effect_lost_in_space()

func set_active(value):
	active = value
	if active and root and root.game_active():
		var robot = root.robot_on_cell(line, col)
		if robot:
			robot.effect_lost_in_space()
	set_view_active()

func get_entering_result(direction):
	if active:
		return {action = CONSTS.lost_in_space}
	return {action = CONSTS.move}