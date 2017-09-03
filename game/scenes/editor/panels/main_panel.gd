extends "editor_panel.gd"

func action_on_cell(line, col):
	editor.show_panel("tile_config")
	editor.sidebar.get_node("tile_config").action_on_cell(line, col)