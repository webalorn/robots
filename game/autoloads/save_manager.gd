extends Node

const SAVE_VERSION = 1
const DIRS = {
	SAVES = "saves"
};

func save_to(file_name, content):
	if typeof(content) == TYPE_OBJECT and content.has_method("save"):
		content = content.save()
	
	var file = File.new()
	# file.open(file_name, file.WRITE)
	file.open("user://test.dat", file.WRITE)
	file.store_string("blabla")
	file.close()

func _ready():
	var dir = Directory.new()
	dir.open("user://")
	for key in DIRS:
		dir.make_dir_recursive("user://"+DIRS[key])