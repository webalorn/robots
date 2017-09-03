extends "editor_panel.gd"

var tile = null
var select_mask = preload("res://scenes/editor/panels/elements/selected_tile.tscn").instance()

func action_on_cell(line, col):
	unselect_tile()
	tile = board.grid[line][col]
	tile.add_child(select_mask)
	get_node("content/scroll/content/description").set_text("TILE_DESCRIPTION_" + tile.tile_type)
	
	get_node("content/rotate").set_hidden(not tile.has_rotation())

func rotate_tile():
	tile.rotation -= 1

func unselect_tile():
	if tile:
		tile.remove_child(select_mask)
		tile = null

func on_hide_panel():
	unselect_tile()
	.on_hide_panel()