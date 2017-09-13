extends Control

var start_loading = false
var added_to_queue = false
var path
var params

func _ready():
	set_process(true)
	
func init(_path, _params):
	path = _path
	params = _params

func _process(delta):
	if not start_loading:
		if path:
			start_loading = true
		else:
			self.queue_free()
	else:
		if not added_to_queue:
			global.current_scene.queue_free()
			global.ress_loader.queue_resource(path)
			added_to_queue = true
		else:
			if global.ress_loader.is_ready(path):
				var s = global.ress_loader.get_resource(path)
				var current_scene = s.instance()
				if current_scene.has_method("scene_init"):
					current_scene.scene_init(params)
				
				get_tree().get_root().add_child(current_scene)
				get_tree().set_current_scene(current_scene)
				global.current_scene = current_scene
		
				self.queue_free()