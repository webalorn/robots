extends Control

func _ready():
	print(get_size())

func button_press():
	print("pressed !")
	get_node("activated").set_hidden(false)