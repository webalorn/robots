extends "floor_tile.gd"

var pushed = false
var targets = {}

func save():
	var s = .save()
	s.targets = []
	for key in targets:
		s.targets.push_back({line = key.x, col = key.y})
	return s

func load_refs_from(s):
	for pos in s.targets:
		add_target(root.grid[pos.line][pos.col])

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
	var linked_inverted = {}
	for key in targets:
		if not linked_inverted.has(key):
			targets[key].set_is_active(not targets[key].is_active())
		if targets[key].has_method("link_to") and targets[key].linked_to: # Do not invert twice the same couple of portals
			linked_inverted[Vector2(targets[key].linked_to.line, targets[key].linked_to.col)] = true
	set_view_pushed_state()

func convert_from(old_tile):
	.convert_from(old_tile)
	if old_tile.has_method("add_target"):
		for key in old_tile.targets:
			add_target(old_tile.targets[key])

func set_view_pushed_state():
	if self.pushed:
		set_anim("pushed")
	else:
		set_anim("default")

func _init(a, b, c).(a, b, c):
	pass