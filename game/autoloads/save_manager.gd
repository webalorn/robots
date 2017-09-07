extends Node

const SAVE_VERSION = 1

func ensure_dir_exist(path):
	Directory.new().make_dir_recursive(path)

func save_to(file_name, content):
	if typeof(content) == TYPE_OBJECT and content.has_method("save"):
		content = content.save()
	
	ensure_dir_exist(file_name.get_base_dir())
	
	var file = File.new()
	file.open(file_name, file.WRITE)
	file.store_string(content.to_json())
	file.close()

func copy_array(array):
	var output = []
	for value in array:
		if typeof(value) == TYPE_DICTIONARY:
			output.push_back(copy_dictionary(value))
		elif typeof(value) == TYPE_ARRAY:
			output.push_back(copy_array(value))
		else:
			output.push_back(value)

func copy_dictionary(dictionary):
	var output = {}
	for key in dictionary.keys():
		var value = dictionary[key]
		if typeof(value) == TYPE_DICTIONARY:
			output[key] = copy_dictionary(value)
		elif typeof(value) == TYPE_ARRAY:
			output[key] = copy_array(value)
		else:
			output[key] = value
	return output

func read(file_name):
	var file = File.new()
	if not file_name or not file.file_exists(file_name):
		return null
	file.open(file_name, file.READ)
	var json = file.get_line()
	var data = {}
	data.parse_json(json)
	return data

func list_files(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var files = []
		
		var read = dir.get_next()
		while read:
			if dir.file_exists(read):
				files.push_back(read)
			read = dir.get_next()
		return files
	else:
		return []