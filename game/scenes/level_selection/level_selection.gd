extends "res://scenes/base_scene.gd"

var active_view = null

func _ready():
	for view in get_node("gui/content").get_children():
		view.set_hidden(true)
	# show_view("chapters")
	show_view(get_parameter("default_view", "chapters"),
		get_parameter("default_view_params", {})
	)

func exit():
	global.goto_scene("main_menu")

func show_view(name, params = null):
	if active_view:
		active_view.set_hidden(true)
	active_view = get_node("gui/content/" + name)
	active_view.set_hidden(false)
	if active_view.has_method("_on_show"):
		active_view._on_show(params)

func _notification(what):
	if OS.get_name() == "Android" and global.is_android_return(what):
		exit()