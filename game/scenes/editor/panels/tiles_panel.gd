extends "editor_panel.gd"

var active setget set_active_type

func action_on_cell(line, col):
	if active:
		var TYPE_CLASS = board.TILE_CLASS.get_type_class(active.type)
		if board.robot_on_cell(line, col):
			if not TYPE_CLASS.is_safe_for_robot():
				editor.notify(tr("TILE_CANT_BE_PLACED_UNDER_ROBOT"))
				return
		var tile = board.set_tile_type(line, col, active.type)
		if tile != null:
			editor.add_step()

func set_active_type(type):
	if active:
		active.set_active(false)
		active = null
	if type:
		active = type
		active.set_active(true)