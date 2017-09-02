extends "../tile.gd"

func _init(a, b, c).(a, b, c):
	pass

func get_entering_result(direction):
	return {action = CONSTS.move}

static func is_safe_for_robot():
	return true