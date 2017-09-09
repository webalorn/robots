extends Node

onready var extension = Globals.get("levels/extension")

func get_levels_list(path):
	var files = []
	
	for f in save_manager.list_files(path):
		if f.ends_with(extension):
			files.append(f)
	files.sort()
	return files

func get_level_name(filename):
	return filename.substr(0, filename.length() - extension.length())

func get_level_path(folder_path, name):
	return folder_path + "/" + name + extension

func get_next_level(level_path):
	if not level_path:
		return
	var file_name = level_path.get_file()
	var dir_path = level_path.get_base_dir()
	
	var sorted_files = get_levels_list(dir_path)
	for i in range(sorted_files.size()-1):
		if sorted_files[i] == file_name:
			return dir_path + "/" + sorted_files[i+1]
	return null