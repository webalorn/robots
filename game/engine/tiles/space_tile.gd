extends "../tile.gd"

func _init(a, b).(a, b):
	pass

func get_entering_result(direction):
	return {action = CONSTS.lost_in_space}