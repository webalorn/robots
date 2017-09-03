extends "editor_panel.gd"

func action_on_cell(line, col):
	editor.show_panel("tile_config")
	editor.sidebar.get_node("tile_config").action_on_cell(line, col)

func handle_return_action():
	var exit_popup = editor.get_node("popups/exit_editor")
	if exit_popup.is_visible():
		exit_popup.hide()
	else:
		editor.show_popup("exit_editor")