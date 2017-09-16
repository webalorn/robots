extends "editor_panel.gd"

func handle_return_action():
	var exit_popup = editor.get_node("popups/exit_editor")
	if exit_popup.is_visible():
		exit_popup.hide()
	else:
		editor.show_popup("exit_editor")