extends "editor_panel.gd"

var tile = null
var specific_config = null
var select_mask = preload("res://scenes/editor/panels/elements/selected_tile.tscn").instance()

func action_on_cell(line, col):
	if specific_config and specific_config.intercept_action:
		specific_config.handle_action(board.grid[line][col])
		return
	
	unselect_tile()
	tile = board.grid[line][col]
	tile.add_child(select_mask)
	get_node("content/scroll/content/description").set_text("TILE_DESCRIPTION_" + tile.tile_type)
	
	get_node("content/rotate").set_hidden(not tile.has_rotation())
	if tile.has_method("set_active"):
		get_node("content/scroll/content/state").set_hidden(false)
		get_node("content/scroll/content/state/check").set_pressed(tile.active)
	else:
		get_node("content/scroll/content/state").set_hidden(true)
	
	if tile.tile_type == "portal":
		specific_config = preload("res://scenes/editor/panels/tiles_config/config_portal.tscn")
	elif tile.tile_type == "magic_wall":
		specific_config = preload("res://scenes/editor/panels/tiles_config/config_magic_wall.tscn")
	elif tile extends preload("res://engine/tiles/generic_button_tile.gd"):
		specific_config = preload("res://scenes/editor/panels/tiles_config/config_buttons.tscn")
	elif tile.tile_type == "end":
		specific_config = preload("res://scenes/editor/panels/tiles_config/config_end.tscn")
	if specific_config:
		specific_config = specific_config.instance()
		specific_config.tile = tile
		specific_config.panel = self
		get_node("content/scroll/content").add_child(specific_config)

func rotate_tile():
	tile.rotation -= 1

func set_tile_active(value):
	tile.active = value
	set_safe_for_robot()

func unselect_tile():
	if tile:
		tile.remove_child(select_mask)
		tile = null
	if specific_config:
		specific_config.queue_free()
		specific_config = null

func on_hide_panel():
	unselect_tile()
	.on_hide_panel()

func set_safe_for_robot():
	if tile and not tile.is_safe_for_robot():
		var robot = board.robot_on_cell(tile.line, tile.col)
		if robot:
			board.remove_robot(robot.robot_id)

####################
##  Undo changes  ##
####################

func save_state_before_undo():
	var datas = {line = tile.line, col = tile.col}
	unselect_tile()
	return datas

func on_undo_action(datas):
	var line = datas.line
	var col = datas.col
	if not board.pos_in_grid(line, col):
		exit_panel()
		return
	action_on_cell(line, col)