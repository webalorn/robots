extends Control

func auto_resize_notify(ratio, screen_size):
	var sidebar = get_node("../gui/sidebar")
	print("-")
	var left_size = sidebar.get_size().x * ratio.x
	set_pos(Vector2(left_size, 0))
	set_size(Vector2(screen_size.x-left_size, get_size().y))