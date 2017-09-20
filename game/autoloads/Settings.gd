extends Node

var location = Globals.get("settings_path")
var config = ConfigFile.new()

func _ready():
	if global.file_exists(location):
		config.load(location)
	init_params()

func save():
	config.save(location)

func get_val(section, key, default = null):
	return config.get_value(section, key, default)

func set_val(section, key, value):
	config.set_value(section, key, value)

###########################
##  Specific parameters  ##
###########################

func set_locale(value):
	set_val("config", "locale", value)
	TranslationServer.set_locale(value)

func get_locale():
	return get_val("config", "locale", OS.get_locale())

func init_params():
	TranslationServer.set_locale(get_locale())