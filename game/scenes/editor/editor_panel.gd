extends Panel

var board

func _ready():
	set_hidden(true)
	var editor = get_parent().get_parent().get_parent()
	board = get_node("/root/editor/gui/level/view/board")

func action_on_cell(line, col):
	pass