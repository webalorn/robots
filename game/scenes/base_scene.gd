extends Control

### This class class host the common properties between all scenes

var gui_resize_node = "gui"
var popups_node = "popups"

func _ready():
	if global.on_android():
		get_tree().set_auto_accept_quit(false)
	pass

#######################
##  Return and exit  ##
#######################

func exit():
	global.goto_scene("main_menu")

func handle_return_action():
	exit()

func _notification(what):
	if OS.get_name() == "Android" and global.is_android_return(what):
		var active_popups = false
		if has_node(popups_node):
			for popup in get_node(popups_node).get_children():
				if popup.is_visible():
					popup.hide()
					active_popups = true
		if not active_popups:
			handle_return_action()

#####################
##   Scene params  ##
#####################

var scene_params = {}

func scene_init(params):
	scene_params = params

func get_parameter(name, default_value = null):
	if scene_params.has(name):
		return scene_params[name]
	return default_value

#####################
##  Popups system  ##
#####################

func show_popup(name):
	get_node(popups_node).get_node("background").popup()
	var popup = get_node(popups_node).get_node(name)
	popup.popup()
	get_node(gui_resize_node).center_node(popup)
	return popup