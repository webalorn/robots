extends Control

var path = Globals.get("levels/editor_store_path")
var extension = Globals.get("levels/extension")
const FILE_ITEM_CLASS = preload("res://scenes/editor_files/file.tscn")

var selected = null
var list_node

func get_path_to(level):
	return path + "/" + level + extension

func _ready():
	var levels_files = save_manager.list_files(path)
	var levels = []
	var f = File.new()
	for level in levels_files:
		if level.ends_with(extension):
			var name = level.substr(0, level.length() - extension.length())
			levels.push_back([f.get_modified_time(get_path_to(name)), name])
	levels.sort_custom(self, "files_comp")
	
	list_node = get_node("gui/files/scroll/list")
	for level in levels:
		var item = FILE_ITEM_CLASS.instance()
		item.name = level[1]
		list_node.add_child(item)
	
	show_gui_selected(false)

func exit():
	global.goto_scene("main_menu")

func show_popup(name):
	get_node("popups/background").popup()
	get_node("popups/" + name).popup()
	get_node("gui").center_elements()

func show_gui_selected(is_level_selected):
	var side = get_node("gui/sidebar/content")
	side.get_node("delete").set_hidden(!is_level_selected)
	side.get_node("rename").set_hidden(!is_level_selected)
	side.get_node("load").set_hidden(!is_level_selected)
	# TODO

func set_selected(level):
	if selected:
		selected.set_is_selected(false)
	if level:
		selected = level
		level.set_is_selected(true)
		show_gui_selected(true)
	else:
		show_gui_selected(false)
		selected = null

func _on_action_new():
	get_node("popups/new_level").init_before_popup(null)
	show_popup("new_level")

func _on_action_delete():
	get_node("popups/delete_confirm/name").set_text(selected.name)
	show_popup("delete_confirm")

func _on_action_rename():
	get_node("popups/rename").init_before_popup(selected.name)
	show_popup("rename")

func _on_action_load():
	launch_editor(selected.name)

func _on_delete_confirm():
	var dir = Directory.new()
	if dir.remove(get_path_to(selected.name)) == OK:
		selected.queue_free()
		set_selected(null)

func rename_file(new_name):
	var old_name = selected.name
	var dir = Directory.new()
	if dir.rename(get_path_to(old_name), get_path_to(new_name)) == OK:
		selected.set_name(new_name)

func launch_editor(level_name):
	var filename = get_path_to(level_name)
	global.goto_scene("editor", {level = filename})

func _notification(what):
	if OS.get_name() == "Android" and global.is_android_return(what):
		exit()

func files_comp(file1, file2):
	if file1[0] > file2[0]:
		return true
	return false