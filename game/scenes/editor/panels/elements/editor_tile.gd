extends Control

export(String) var type = "floor"
const TILE_CLASS = preload("res://engine/tile.gd")
var panel

func _ready():
	get_node("icon").set_texture(TILE_CLASS.get_tile_icon_texture(type))
	panel = get_node("/root/editor/gui/sidebar/tiles")

func set_active(state):
	get_node("activated").set_hidden(not state)

func button_press():
	if get_node("activated").is_visible():
		set_active(false)
		panel.set_active_type(null)
	else:
		set_active(true)
		panel.set_active_type(self)