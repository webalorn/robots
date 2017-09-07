extends Control

export(String) var name
export(String) var description
export(String) var directory

func _ready():
	get_node("content/title").set_text(tr(name))
	get_node("content/description").set_text(tr(description))

func _on_chapter_pressed():
	get_node("/root/level_selection").show_view("levels", {
		path = Globals.get("levels/game_levels_location") + "/" + directory
	})