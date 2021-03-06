extends "res://scenes/base_scene.gd"

var path = Globals.get("levels/editor_store_path")
var extension = Globals.get("levels/extension")
const FILE_ITEM_CLASS = preload("res://scenes/editor_files/file.tscn")

var selected = null
var list_node

func get_path_to(level):
	return path + "/" + level + extension

func show_files():
	var levels_files = save_manager.list_files(path)
	var levels = []
	var f = File.new()
	for level in levels_files:
		if level.ends_with(extension):
			var name = level.substr(0, level.length() - extension.length())
			levels.push_back([f.get_modified_time(get_path_to(name)), name])
	levels.sort_custom(self, "files_comp")
	
	list_node = get_node("gui/files/scroll/list")
	for old_file in list_node.get_children():
		old_file.queue_free()
	for level in levels:
		var item = FILE_ITEM_CLASS.instance()
		item.name = level[1]
		list_node.add_child(item)
	
	show_gui_selected(false)
	
func _ready():
	show_files()
	
	if Globals.get("application/master_build"):
		_init_master_build()

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

func files_comp(file1, file2):
	if file1[0] > file2[0]:
		return true
	return false

######################
##  admin features  ##
######################

func _init_master_build():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("config_f1"):
		var p = show_popup("change_folder")
		p.set_current_dir("res://data/levels")

func change_folder(dir):
	path = dir
	Globals.set("levels/editor_store_path", path)
	show_files()