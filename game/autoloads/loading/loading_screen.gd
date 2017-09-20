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
	if not start_loading: # Wait next frame
		if path:
			start_loading = true
		else:
			self.queue_free()
		return
	
	if params.has("loading_screen"): # Put a loading image on screen
		var loading = params["loading_screen"]
		params.erase("loading_screen")
		get_node("image").set_texture(load(loading))
		return
	
	global.current_scene.queue_free()
	var s = load(path)
	var current_scene = s.instance()
	if current_scene.has_method("scene_init"):
		current_scene.scene_init(params)
	
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	global.current_scene = current_scene

	self.queue_free()