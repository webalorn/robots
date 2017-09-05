extends Control

### This class class host the common properties between all scenes

func _ready():
	pass

#####################
##   Scene params  ##
#####################

var scene_params

func scene_init(params):
	scene_params = params

func get_parameter(name, default_value = null):
	if scene_params.has(name):
		return scene_params[name]
	return default_value

#####################
##  Popups system  ##
#####################

var gui_resize_node = "gui"
var popups_node = "popups"

func show_popup(name):
	get_node(popups_node).get_node("background").popup()
	var popup = get_node(popups_node).get_node(name)
	popup.popup()
	get_node(gui_resize_node).center_node(popup)
	return popup