extends Control

var LEVEL_ITEM_CLASS = preload("level_item.tscn")

var params

func _on_show(_params):
	params = _params
	
	var list = get_node("scroll/list")
	for child in list.get_children():
		child.queue_free()
	
	var files = level_manager.get_levels_list(params.path)
	for level in files:
		var id = level_manager.get_level_name(level)
		var item = LEVEL_ITEM_CLASS.instance()
		item.id = id
		item.path = level_manager.get_level_path(params.path, id)
		list.add_child(item)

func handle_return_action(root):
	root.show_view("chapters")