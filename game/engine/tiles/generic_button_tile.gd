extends "floor_tile.gd"

var pushed = false

var targets = {}

func _remove_target_by_key(key):
	targets[key].disconnect("exit_tree", self, "remove_target")
	targets.erase(key)

func add_target(tile):
	var key = Vector2(tile.line, tile.col)
	if targets.has(key):
		_remove_target_by_key(key)
	targets[key] = tile
	tile.connect("exit_tree", self, "remove_target", [tile])

func remove_target(tile):
	var key = Vector2(tile.line, tile.col)
	if targets.has(key) and targets[key] == tile:
		_remove_target_by_key(key)

func invert_state():
	pushed = not pushed
	for key in targets:
		targets[key].set_is_active(not targets[key].is_active())

func _init(a, b, c).(a, b, c):
	pass