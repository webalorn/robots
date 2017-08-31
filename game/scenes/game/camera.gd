extends Camera2D

export var margin_size = 0.2
var root
var board
var game

var zoom_min = 3
var zoom_max = 0.5
var zoom_speed = 1.5

func change_parent(new_parent):
	self.get_parent().remove_child(self)
	new_parent.add_child(self)

func _ready():
	root = get_parent()
	game = get_node("/root/game")
	board = get_node("../board")
	set_process_input(true)

### Zoom and move utility functions ###

func get_sizes_ratio():
	var actual_size = get_viewport().get_rect().size
	var base_size = Vector2(Globals.get("display/width"), Globals.get("display/height"))
	var ratio = min(actual_size.x / float(base_size.x), actual_size.y / float(base_size.y))
	return ratio

func quotient_by_zoom(vect):
	return Vector2(vect.x / get_zoom().x, vect.y / get_zoom().y)
	
func product_by_zoom(vect):
	return Vector2(vect.x * get_zoom().x, vect.y * get_zoom().y)

func get_board_top_left():
	var decal = quotient_by_zoom(get_camera_pos())
	return game.get_item_rect().size * 0.5 - decal

func pixel_to_grid_pos(pixel_pos):
	return product_by_zoom(pixel_pos - get_board_top_left())

func set_pos(position):
	var board_size = board.get_board_size()
	position.x = max(min(position.x, board_size.x), 0)
	position.y = max(min(position.y, board_size.y), 0)
	.set_pos(position)

func set_zoom(value):
	var ratio = get_sizes_ratio()
	var v = max(min(zoom_min / ratio, value.x), zoom_max / ratio)
	.set_zoom(Vector2(v, v))

func drag_event(move):
	move = product_by_zoom(move)
	set_pos(get_pos() - move)
	align()
	force_update_scroll()

### Zoom and move main functions ###

var first_distance =0
var events={}
var percision = 1
var current_zoom
var center

func dist():
    var first_event =null
    for event in events:
        if first_event!=null:
            return events[event].pos.distance_to(first_event.pos)
        first_event = events[event]

func center():
    var first_event = null
    for event in events:
        if first_event!=null:
            return (map_pos(events[event].pos) + map_pos(first_event))/2
            break
        first_event = events[event].pos

func map_pos(pos):
	var mtx = get_viewport().get_canvas_transform()
	var mt = mtx.affine_inverse()
	var p = mt.xform(pos)
	return p

func handle_input(event):

	if event.type == InputEvent.SCREEN_TOUCH and event.is_pressed():
		events[event.index]=event
	
		if events.size()>1:
			current_zoom = get_zoom()
			first_distance = dist()
			center = center()
	elif event.type == InputEvent.SCREEN_TOUCH and not event.is_pressed():
		events.erase(event.index)
	elif event.type == InputEvent.SCREEN_DRAG :
		events[event.index] = event
		
		if events.size()>1:
			var second_distance = dist()
			if abs(first_distance-second_distance) > percision:
				var new_zoom = Vector2(first_distance / second_distance, first_distance / second_distance)
				var zoom = new_zoom*current_zoom
				set_zoom(zoom)
				#set_global_pos(center)
		elif events.size()==1:
			#set_global_pos(get_global_pos()-event.relative_pos*get_zoom()*2)
			drag_event(event.relative_pos)