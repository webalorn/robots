extends "res://scenes/game/generic_input_manager.gd"

func handle_touch_cell(line, col):
	if game.board.pos_in_grid(line, col):
		game.get_active_panel().action_on_cell(line, col)

func is_long_touch_enabled():
	return game.get_active_panel().has_method("action_on_cell_long_touch")

func handle_long_touch_cell(line, col):
	if game.board.pos_in_grid(line, col):
		global.vibrate()
		game.get_active_panel().action_on_cell_long_touch(line, col)

func _init(_editor).(_editor):
	pass