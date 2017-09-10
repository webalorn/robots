extends "res://scenes/base_scene.gd"

var buttons

func play():
	global.goto_scene("level_selection")

func load_editor():
	global.goto_scene("editor_files")

func exit():
	get_tree().quit()

func _ready():
	buttons = get_node("gui/buttonsPanel/buttonsContainer")
	buttons.get_node("start").connect("pressed", self, "play")
	buttons.get_node("editor").connect("pressed", self, "load_editor")
	buttons.get_node("exit").connect("pressed", self, "exit")