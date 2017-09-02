extends "res://scenes/game/generic_input_manager.gd"

func handle_touch_cell(line, col):
	if game.board.pos_in_grid(line, col):
		game.get_active_panel().action_on_cell(line, col)

func _init(_editor).(_editor):
	pass