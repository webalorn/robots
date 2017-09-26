extends Node

var game
var touchs_events = {}
var touch_event_move = {}
var touch_event_time = {}
const touch_dist_max = 4
const long_touch_duration = 500

func zoom_in_wheel():
	game.camera.set_zoom(game.camera.get_zoom()*0.9)

func zoom_out_wheel():
	game.camera.set_zoom(game.camera.get_zoom()/0.9)

func handle_touch_cell(line, col):
	pass

func is_long_touch_enabled():
	return self.has_method("handle_long_touch_cell")

func game_touch_manage(pos, duration):
	if pos.x < 0 or pos.y < 0:
		return
	pos = game.camera.pixel_to_grid_pos(pos) / game.board.tile_size # Get pos in term of cells
	var line = floor(pos.y) # Get cell coords with integers
	var col = floor(pos.x)
	
	if duration < long_touch_duration or not is_long_touch_enabled():
		handle_touch_cell(line, col)
	else:
		handle_long_touch_cell(line, col)

func end_touch_event(index):
	if touchs_events.has(index) and touchs_events[index] != null:
		var dist = touch_event_move[index]
		if dist <= touch_dist_max:
			game_touch_manage(touchs_events[index], OS.get_ticks_msec() - touch_event_time[index])
	touchs_events.erase(index)
	touch_event_time.erase(index)
	touch_event_move.erase(index)

func event_touch(pos, index, is_pressed):
	if is_pressed:
		touchs_events[index] = pos
		touch_event_time[index] = OS.get_ticks_msec()
		touch_event_move[index] = 0
		if touchs_events.size() > 1:
			for key in touchs_events:
				touchs_events[key] = null
	else:
		end_touch_event(index)

func event_move(relative_pos, index):
	if touchs_events.has(index) and touchs_events[index] != null:
		touch_event_move[index] += abs(relative_pos.x) + abs(relative_pos.y)
		touchs_events[index] += relative_pos

func _unhandled_input(ev):
	var gui = game.get_node("gui")
	if not game.is_game_input_active():
		return false
	if not global.on_phone():
		if ev.type == InputEvent.MOUSE_MOTION:
			if Input.is_mouse_button_pressed(BUTTON_LEFT):
				game.camera.drag_event(ev.relative_pos)
				event_move(ev.relative_pos, 1)
		elif ev.type == InputEvent.MOUSE_BUTTON:
			if ev.button_index == BUTTON_WHEEL_UP:
				zoom_in_wheel()
			elif ev.button_index == BUTTON_WHEEL_DOWN:
				zoom_out_wheel()
			elif ev.button_index == BUTTON_LEFT:
				event_touch(ev.pos, 1, ev.is_pressed())
	else:
		if ev.type == InputEvent.SCREEN_TOUCH:
			event_touch(ev.pos, ev.index, ev.is_pressed())
		elif ev.type == InputEvent.SCREEN_DRAG:
			event_move(ev.relative_pos, ev.index)
		game.camera.handle_input(ev)

func _process(delta):
	if is_long_touch_enabled():
		for key in touchs_events:
			if touchs_events[key] != null and OS.get_ticks_msec() - touch_event_time[key] > long_touch_duration:
				end_touch_event(key)

func _init(_scene_root):
	game = _scene_root
	set_process_unhandled_input(true)
	set_process(true)