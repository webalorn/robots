extends Control

export(String) var name = "name"

func _ready():
	get_node("name").set_text(tr(name))