extends Control

var buttons

func load_test_game():
	get_node("/root/global").goto_scene("game", {"level":"some_path"})

func exit_game():
	get_tree().quit()

func _ready():
	buttons = get_node("gui/buttonsPanel/buttonsContainer")
	buttons.get_node("start").connect("pressed", self, "load_test_game")
	buttons.get_node("exit").connect("pressed", self, "exit_game")
	
#	get_tree().set_auto_accept_quit(false)
	print(OS.get_name(), " debug: ", OS.is_debug_build())

func _notification(what):
	if global.is_android_return(what):
		exit_game()