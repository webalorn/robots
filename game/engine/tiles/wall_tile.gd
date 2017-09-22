extends "../tile.gd"

func _init(a, b, c).(a, b, c):
	pass

func get_projectile_entering_result(direction, type):
	return {result = CONSTS.result_blocked}