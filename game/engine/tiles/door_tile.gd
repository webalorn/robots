extends "../tile.gd"

var active = true setget set_active

func _init(a, b, c).(a, b, c):
	pass

func set_active(value):
	active = value
	if active and root:
		var robot = root.robot_on_cell(line, col)
		if robot:
			robot.effect_destroyed()
	set_view_active()

func get_entering_result(direction):
	if active:
		return {action = CONSTS.blocked}
	return {action = CONSTS.move}