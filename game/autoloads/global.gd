extends Node

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)

func goto_scene(path, params = {}):
	if not path.begins_with("res://"):
		path = "res://scenes/" + path + "/" + path + ".tscn"
	call_deferred("_deferred_goto_scene", path, params)

func _deferred_goto_scene(path, params):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	if current_scene.has_method("scene_init"):
		current_scene.scene_init(params)
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)