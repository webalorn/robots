extends Panel

var board
var editor

func _ready():
	set_hidden(true)
	editor = get_parent().get_parent().get_parent()
	board = get_node("/root/editor/gui/level/view/board")

func action_on_cell(line, col):
	pass

func on_show_panel():
	pass

func on_hide_panel():
	pass