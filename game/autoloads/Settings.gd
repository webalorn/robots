extends Node

var location = Globals.get("settings_path")
var config = ConfigFile.new()

func _ready():
	if global.file_exists(location):
		config.load(location)

func save():
	config.save(location)

func get(section, key, default = null):
	return config.get_value(section, key, default)

func set(section, key, value):
	config.set_value(section, key, value)