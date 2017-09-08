extends Control

var LEVEL_ITEM_CLASS = preload("level_item.tscn")

var params

func _on_show(_params):
	params = _params
	var path = params.path
	var files = []
	var extension = Globals.get("levels/extension")
	var list = get_node("scroll/list")
	
	for child in list.get_children():
		child.queue_free()
	
	for f in save_manager.list_files(path):
		if f.ends_with(extension):
			files.append(f)
	files.sort()
	for level in files:
		var id = level.substr(0, level.length() - extension.length())
		var item = LEVEL_ITEM_CLASS.instance()
		item.id = id
		item.path = path + "/" + id + extension
		list.add_child(item)

func handle_return_action(root):
	root.show_view("chapters")