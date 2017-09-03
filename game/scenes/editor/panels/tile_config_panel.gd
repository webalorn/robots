extends "editor_panel.gd"

var tile

func action_on_cell(line, col):
	tile = board.grid[line][col]
	get_node("content/scroll/content/description").set_text("TILE_DESCRIPTION_" + tile.tile_type)
	
	get_node("content/rotate").set_hidden(not tile.has_rotation())
	