extends "res://scenes/base_scene.gd"

func _ready():
	var langs = get_tree().get_nodes_in_group("lang_buttons")
	for lang in langs:
		if lang.get_name() == Settings.get_locale():
			lang.set_pressed(true)

func _exit_tree():
	Settings.save()

func set_lang(value):
	Settings.set_locale(value)

func _on_goto_about():
	global.goto_scene("about")
