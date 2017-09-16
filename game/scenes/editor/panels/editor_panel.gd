extends Panel

var board
var editor

func _ready():
	set_hidden(true)
	editor = get_parent().get_parent().get_parent()
	board = get_node("/root/editor/level/view/board")

func action_on_cell(line, col):
	editor.show_panel("tile_config")
	editor.sidebar.get_node("tile_config").action_on_cell(line, col)

func on_show_panel():
	pass

func on_hide_panel():
	pass

func exit_panel():
	editor.show_panel("main")

func handle_return_action():
	exit_panel()

func save_state_before_undo():
	return {}

func on_undo_action(datas):
	on_show_panel()