extends Node

var current_scene = null
var loading_screen = preload("res://autoloads/loading_screen.tscn")

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func goto_scene(path, params = {}):
	if not path.begins_with("res://"):
		path = "res://scenes/" + path + "/" + path + ".tscn"
	call_deferred("_deferred_goto_scene", path, params)

func _deferred_goto_scene(path, params):
	current_scene.free()
	var loading = loading_screen.instance()
	get_tree().get_root().add_child(loading)
	
	yield(get_tree(), "idle_frame")
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	if current_scene.has_method("scene_init"):
		current_scene.scene_init(params)
	
	loading.free()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)

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