extends Control

### This class class host the common properties between all scenes

func _ready():
	pass

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