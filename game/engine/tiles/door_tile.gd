extends "../tile.gd"

var active = true setget set_active

func _init(a, b, c).(a, b, c):
	pass

func is_safe_for_robot():
	return not active

func set_active(value):
	active = value
	if active and root:
		var robot = root.robot_on_cell(line, col)
		if robot:
			robot.effect_destroyed()
	set_view_active()

func get_projectile_entering_result(direction, type):
	if active:
		return {result = CONSTS.result_blocked}
	return {result = CONSTS.result_continue}