extends "tile_config.gd"

var targets = {}
var TARGET_MARKER_CLASS = preload("res://scenes/editor/panels/elements/target_tile.tscn")

func _ready():
	display_elements()
	for key in tile.targets:
		add_marker(panel.board.grid[key.x][key.y], key)

func _exit_tree():
	for key in targets:
		targets[key].queue_free()

func display_elements():
	get_node("select").set_hidden(intercept_action)
	get_node("text_action").set_hidden(not intercept_action)
	get_node("cancel").set_hidden(not intercept_action)
	get_node("nb").set_text(str(tile.targets.size()))

func add_marker(target_tile, key):
	var marker = TARGET_MARKER_CLASS.instance()
	target_tile.add_child(marker)
	targets[key] = marker

func handle_action(action_tile):
	var key = Vector2(action_tile.line, action_tile.col)
	if targets.has(key):
		targets[key].queue_free()
		targets.erase(key)
		tile.remove_target(action_tile)
	elif action_tile.has_method("set_active"):
		tile.add_target(action_tile)
		add_marker(action_tile, key)
	display_elements()

func _on_select_targets():
	intercept_action = true
	display_elements()

func _on_cancel_action():
	intercept_action = false
	display_elements()