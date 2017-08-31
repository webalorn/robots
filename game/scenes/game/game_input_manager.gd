extends Node

var game

func zoom_in_wheel():
	game.camera.set_zoom(game.camera.get_zoom()*0.9)

func zoom_out_wheel():
	game.camera.set_zoom(game.camera.get_zoom()/0.9)

func _input(ev):
	#if ev.type == InputEvent.MOUSE_BUTTON:
	#	var pos = ev.pos - top_left
	#	pos = game.camera.product_by_zoom(pos)
	#	# print("Mouse Click/Unclick at: ", pos)
	#elif (ev.type==InputEvent.MOUSE_MOTION):
	#	print("Mouse Motion at: ",ev.pos).
	if not global.on_phone():
		if ev.type == InputEvent.MOUSE_MOTION:
			if Input.is_mouse_button_pressed(BUTTON_LEFT):
				game.camera.drag_event(ev.relative_pos)
		elif ev.type == InputEvent.MOUSE_BUTTON:
			if ev.button_index == BUTTON_WHEEL_UP:
				zoom_in_wheel()
			elif ev.button_index == BUTTON_WHEEL_DOWN:
				zoom_out_wheel()
	else:
		game.camera.handle_input(ev)

func _init(_game):
	game = _game
	set_process_input(true)