extends Node

var current_scene = null
var loading_screen = preload("res://autoloads/loading/loading_screen.tscn")
var ress_loader

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	ress_loader = preload("loading/resource_queue.gd").new()
	ress_loader.start()

##################
##    Scenes    ##
##################

func goto_scene(path, params = {}):
	if not path.begins_with("res://"):
		path = "res://scenes/" + path + "/" + path + ".tscn"
	call_deferred("_deferred_goto_scene", path, params)

func _deferred_goto_scene(path, params):
	var loading = loading_screen.instance()
	get_tree().get_root().add_child(loading)
	loading.init(path, params)

#################
##  Platforms  ##
#################

func on_phone():
	if OS.get_name() in ["Android", "iOS"]:
		return true
	return false

func is_android_return(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST and global.on_android():
		return true
	return false

func on_android():
	if OS.get_name() == "Android":
		return true
	return false