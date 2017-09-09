extends PopupPanel

var robots_added = false

func set_size_scale(ratio):
	set_scale(ratio)
	set_global_pos(get_node("../anchor").get_global_pos())

func popup():
	.popup()
	var gui = get_node("/root/editor/gui")
	set_size_scale(gui.last_ratio)
	if not robots_added:
		robots_added = true
		add_robots()

func auto_resize_notify(scale, v2):
	set_size_scale(scale)

func on_robot_selected(robot_id):
	hide()
	get_parent().get_parent().emit_signal("robot_selected", robot_id)

func add_robot_item(id, texture):
	var item = preload("robot_selector_item.tscn").instance()
	item.set_normal_texture(texture)
	item.connect("pressed", self, "on_robot_selected", [id])
	get_node("list").add_child(item)

func add_robots():
	var ROBOTS_CLASS = preload("res://engine/robot.gd")
	add_robot_item(null, preload("res://gui/editor/none.png"))
	for robot in ROBOTS_CLASS.existants_ids:
		add_robot_item(robot, ROBOTS_CLASS.get_robot_icon(robot))