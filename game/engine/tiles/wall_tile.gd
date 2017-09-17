extends "../tile.gd"

func _init(a, b, c).(a, b, c):
	pass

func get_entering_result(direction):
	return {action = CONSTS.blocked}

func get_projectile_entering_result(direction):
	return {result = CONSTS.result_blocked}