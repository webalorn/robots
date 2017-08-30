extends Node

var game

func _input(ev):
	var decal = Vector2(
		game.camera.get_camera_pos().x / game.camera.get_zoom().x,
		game.camera.get_camera_pos().y / game.camera.get_zoom().y
	)
	var top_left = game.get_item_rect().size * 0.5 - decal
		
	if ev.type == InputEvent.MOUSE_BUTTON:
		var pos = ev.pos - top_left
		pos = Vector2(int(pos.x * game.camera.get_zoom().x), int(pos.y * game.camera.get_zoom().y))
		print("Mouse Click/Unclick at: ", pos)
	#elif (ev.type==InputEvent.MOUSE_MOTION):
	#	print("Mouse Motion at: ",ev.pos)

func _init(_game):
	game = _game
	set_process_input(true)