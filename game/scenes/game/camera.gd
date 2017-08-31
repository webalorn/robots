extends Camera2D

export var margin_size = 0.2
var root

var zoom_min = 3
var zoom_max = 0.5

func set_zoom(value):
	var actual_size = get_viewport().get_rect().size
	var base_size = Vector2(Globals.get("display/width"), Globals.get("display/height"))
	var ratio = min(actual_size.x / float(base_size.x), actual_size.y / float(base_size.y))
	
	var tranf_min = zoom_min / ratio
	var tranf_max = zoom_max / ratio
	
	var v = max(min(tranf_min, value.x), tranf_max)
	.set_zoom(Vector2(v, v))

func ready():
	root = get_parent()

func quotient_by_zoom(vect):
	return Vector2(vect.x / get_zoom().x, vect.y / get_zoom().y)
	
func product_by_zoom(vect):
	return Vector2(vect.x * get_zoom().x, vect.y * get_zoom().y)

func change_parent(new_parent):
	self.get_parent().remove_child(self)
	new_parent.add_child(self)