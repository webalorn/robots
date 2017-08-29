extends "floor_tile.gd"

var pushed = false

var targets = {}

func _remove_target_by_key(key):
	targets[key].disconnet("exit_tree", self, "remove_target")
	targets.erase(key)

func add_target(tile):
	var key = Vector2(tile.line, tile.col)
	if targets.has_key(key):
		_remove_target_by_key(key)
	targets[key] = tile
	tile.connect("exit_tree", self, "remove_target", [tile])

func remove_target(tile):
	var key = Vector2(tile.line, tile.col)
	if targets.has_key(key) and targets[key] == tile:
		_remove_target_by_key(key)

func invert_state():
	pushed = not pushed
	for key in targets:
		if targets[key].has_method("set_active"):
			targets[key].active = !targets[key].active

func _init(a, b, c).(a, b, c):
	pass