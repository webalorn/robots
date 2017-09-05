extends Control

var last_size = null
var last_ratio = Vector2(1, 1)

func set_size_and_scale():
	var actual_size = get_viewport().get_rect().size
	if last_size != actual_size:
		last_size = actual_size
		var base_size = Vector2(Globals.get("display/width"), Globals.get("display/height"))
		var ratio = Vector2(actual_size.x / float(base_size.x), actual_size.y / float(base_size.y))
		
		if ratio.x < ratio.y:
			ratio = Vector2(ratio.x, ratio.x)
		else:
			ratio = Vector2(ratio.y, ratio.y)
		
		set_scale(ratio)
		set_size(Vector2(actual_size.x / ratio.x, actual_size.y / ratio.y))
		
		var apply_ratio = Vector2(ratio.x / last_ratio.x, ratio.y / last_ratio.y)
		last_ratio = ratio
		for el in get_tree().get_nodes_in_group("auto_scale"):
			el.set_scale(Vector2(el.get_scale().x * apply_ratio.x, el.get_scale().y * apply_ratio.y))

func center_node(el):
	var actual_size = get_viewport().get_rect().size
	var el_size = Vector2(el.get_size().x * el.get_scale().x, el.get_size().y * el.get_scale().y)
	el.set_pos(Vector2(
		(actual_size.x - el_size.x) / 2,
		(actual_size.y - el_size.y) / 2
	))

func center_elements():
	for el in get_tree().get_nodes_in_group("auto_center"):
		center_node(el)

func _ready():
	set_size_and_scale()
	center_elements()
	if not global.on_phone():
		set_process(true)

func _process(delta):
	if get_viewport().get_rect().size != last_size:
		set_size_and_scale()
		center_elements()