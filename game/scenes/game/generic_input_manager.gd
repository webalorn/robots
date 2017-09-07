extends Node

var game
var touchs_events = {}
var touch_dist_max = 10

func zoom_in_wheel():
	game.camera.set_zoom(game.camera.get_zoom()*0.9)

func zoom_out_wheel():
	game.camera.set_zoom(game.camera.get_zoom()/0.9)

func handle_touch_cell(line, col):
	pass

func game_touch_manage(pos):
	if pos.x < 0 or pos.y < 0:
		return
	pos = game.camera.pixel_to_grid_pos(pos) / game.board.tile_size # Get pos in term of cells
	var line = floor(pos.y) # Get cell coords with integers
	var col = floor(pos.x)
	
	handle_touch_cell(line, col)

func event_touch(pos, index, is_pressed):
	if is_pressed:
		touchs_events[index] = pos
		if touchs_events.size() > 1:
			for key in touchs_events:
				touchs_events[key] = null
	else:
		if touchs_events.has(index) and touchs_events[index] != null:
			var dist = touchs_events[index].distance_to(pos)
			if dist <= touch_dist_max:
				game_touch_manage(pos)
		touchs_events.erase(index)

func _unhandled_input(ev):
	if not game.is_game_input_active():
		return false
	if not global.on_phone():
		if ev.type == InputEvent.MOUSE_MOTION:
			if Input.is_mouse_button_pressed(BUTTON_LEFT):
				game.camera.drag_event(ev.relative_pos)
		elif ev.type == InputEvent.MOUSE_BUTTON:
			if ev.button_index == BUTTON_WHEEL_UP:
				zoom_in_wheel()
			elif ev.button_index == BUTTON_WHEEL_DOWN:
				zoom_out_wheel()
			elif ev.button_index == BUTTON_LEFT:
				event_touch(ev.pos, ev.button_index, ev.is_pressed())
	else:
		if ev.type == InputEvent.SCREEN_TOUCH:
			event_touch(ev.pos, ev.index, ev.is_pressed())
		game.camera.handle_input(ev)

func _init(_scene_root):
	game = _scene_root
	set_process_unhandled_input(true)