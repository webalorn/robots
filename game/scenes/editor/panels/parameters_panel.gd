extends "editor_panel.gd"

var params

func _ready():
	params = get_node("content/scroll/params")

func display_size():
	params.get_node("height/value").set_text(str(board.height))
	params.get_node("width/value").set_text(str(board.width))

func on_show_panel():
	display_size()

func change_height(add):
	board.height += add
	display_size()
	editor.add_step()

func change_width(add):
	board.width += add
	display_size()
	editor.add_step()