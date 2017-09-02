extends "editor_panel.gd"

var active setget set_active_type

func action_on_cell(line, col):
	if active:
		print("place tile at: ", line, " ", col, " of type ", active.type)
		board.set_tile_type(line, col, active.type)

func set_active_type(type):
	if active:
		active.set_active(false)
		active = null
	if type:
		active = type
		active.set_active(true)