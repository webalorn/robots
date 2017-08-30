extends Node

var game
var zoom_min = 3
var zoom_max = 0.5

func get_board_top_left():
	var decal = game.camera.quotient_by_zoom(game.camera.get_camera_pos())
	return game.get_item_rect().size * 0.5 - decal

func pixel_to_grid_pos(pixel_pos):
	return game.camera.product_by_zoom(pixel_pos - get_board_top_left())

func move_in_board(position):
	var board_size = game.board.get_board_size()
	position.x = max(position.x, 0)
	position.y = max(position.y, 0)
	position.x = min(position.x, board_size.x)
	position.y = min(position.y, board_size.y)
	return position

func drag_event(move):
	move = game.camera.product_by_zoom(move)
	# game.board.set_pos(game.board.get_pos() + move)
	game.camera.set_pos(move_in_board(game.camera.get_pos() - move))
	game.camera.align()
	game.camera.force_update_scroll()

func zoom_in_wheel():
	game.camera.set_zoom(game.camera.get_zoom()*0.9)
	if game.camera.get_zoom().x < zoom_max:
		game.camera.set_zoom(Vector2(zoom_max, zoom_max))

func zoom_out_wheel():
	game.camera.set_zoom(game.camera.get_zoom()/0.9)
	if game.camera.get_zoom().x > zoom_min:
		game.camera.set_zoom(Vector2(zoom_min, zoom_min))

func _input(ev):
	#if ev.type == InputEvent.MOUSE_BUTTON:
	#	var pos = ev.pos - top_left
	#	pos = game.camera.product_by_zoom(pos)
	#	# print("Mouse Click/Unclick at: ", pos)
	#elif (ev.type==InputEvent.MOUSE_MOTION):
	#	print("Mouse Motion at: ",ev.pos).
	if ev.type == InputEvent.MOUSE_MOTION:
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			drag_event(ev.relative_pos)
	elif ev.type == InputEvent.MOUSE_BUTTON:
		if ev.button_index == BUTTON_WHEEL_UP:
			zoom_in_wheel()
		elif ev.button_index == BUTTON_WHEEL_DOWN:
			zoom_out_wheel()

func _init(_game):
	game = _game
	set_process_input(true)