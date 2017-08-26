extends Control

var buttons

func load_test_game():
	get_node("/root/global").goto_scene("game", {"level":"some_path"})

func exit_game():
	get_tree().quit()

func _ready():
	buttons = get_node("buttonsPanel/buttonsContainer")
	buttons.get_node("start").connect("pressed", self, "load_test_game")
	buttons.get_node("exit").connect("pressed", self, "exit_game")
