extends "../tile.gd"

func _init(a, b).(a, b):
	pass

func get_entering_result(direction):
	if direction == CONSTS.DIRS.UP and self.has_method("get_entering_special_action"):
		return get_entering_special_action()
	return {action = CONSTS.blocked}