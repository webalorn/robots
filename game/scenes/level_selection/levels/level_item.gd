extends Control

export(String) var id
export(String) var path

func _ready():
	get_node("cell/id").set_text(id)

func _on_select_level():
	global.goto_scene("game", {
		level = path,
		exit_goto = "level_selection",
		exit_text = tr("EXIT"),
		exit_goto_params = {
			default_view = "levels",
			default_view_params = get_node("/root/level_selection").active_view.params
		}
	})