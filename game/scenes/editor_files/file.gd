extends Control

var editor_files
var name = ""

func _ready():
	editor_files = get_node("/root/editor_files")
	get_node("item/filename").set_text(name)

func set_name(value):
	name = value
	get_node("item/filename").set_text(name)

func set_is_selected(selected):
	get_node("item/selected").set_hidden(not selected)

func _on_item_pressed():
	editor_files.set_selected(self)