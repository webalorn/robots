extends Node

var game

func get_board_top_left():
	var decal = game.camera.quotient_by_zoom(game.camera.get_camera_pos())
	return game.get_item_rect().size * 0.5 - decal

func pixel_to_grid_pos(pixel_pos):
	return game.camera.product_by_zoom(pixel_pos - get_board_top_left())

func move_in_board(position):
	var board_size = game.board.get_board_size()
	print(board_size)
	position.x = max(position.x, 0)
	position.y = max(position.y, 0)
	position.x = min(position.x, board_size.x)
	position.y = min(position.y, board_size.y)
	return position

func drag_event(move):
	move = game.camera.product_by_zoom(move)
	game.camera.set_pos(move_in_board(game.camera.get_pos() - move))
	game.camera.align()

func _input(ev):
	#if ev.type == InputEvent.MOUSE_BUTTON:
	#	var pos = ev.pos - top_left
	#	pos = game.camera.product_by_zoom(pos)
	#	# print("Mouse Click/Unclick at: ", pos)
	#elif (ev.type==InputEvent.MOUSE_MOTION):
	#	print("Mouse Motion at: ",ev.pos)
	if ev.type == InputEvent.MOUSE_MOTION:
		if Input.is_mouse_button_pressed(1):
			drag_event(ev.relative_pos)

func _init(_game):
	game = _game
	set_process_input(true)