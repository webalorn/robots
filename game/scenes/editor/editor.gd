extends "res://scenes/base_scene.gd"

var level_file_path

var game_view
var board
var sidebar
var camera
var input_manager

var active_panel
const MAX_NOTIFS = 3

func _ready():
	save_thread = Thread.new()
	set_process(true)
	
	sidebar = get_node("gui/sidebar")
	game_view = get_node("level/view")
	board = game_view.get_node("board")
	camera = board.get_node("camera")
	input_manager = preload("res://scenes/editor/editor_input_manager.gd").new(self)
	
	camera.zoom_min *= 2
	game_view.add_child(input_manager)
	load_level_gameboard()
	camera.set_pos(Vector2(board.width * board.tile_size, board.height * board.tile_size)/2)
	
	# Sidebar
	show_panel("main")

func _process(delta):
	process_auto_save(delta)

func load_level_gameboard():
	var save = save_manager.read(level_file_path)
	if save != null:
		board.load_from(save)
	else:
		board.height = Globals.get("levels/default_size")
		board.width = Globals.get("levels/default_size")
		save_level()

func scene_init(params):
	.scene_init(params)
	level_file_path = params.level

func action_play_level():
	save_level()
	global.goto_scene("game", {
		level = level_file_path,
		exit_goto = "editor",
		exit_text = tr("LEVEL_EDITOR"),
		exit_goto_params = scene_params,
		from_editor = true
	})

func exit():
	save_level()
	global.goto_scene("editor_files")

func is_game_input_active(): #For popups, etc... If needed !
	return true

func show_panel(name):
	if active_panel:
		sidebar.get_node(active_panel).on_hide_panel()
		sidebar.get_node(active_panel).set_hidden(true)
	active_panel = name
	sidebar.get_node(active_panel).set_hidden(false)
	sidebar.get_node(active_panel).on_show_panel()

func get_active_panel():
	return sidebar.get_node(active_panel)

func notify(text):
	var notifs = get_node("gui/notifications")
	if notifs.get_children().size() >= MAX_NOTIFS:
		var first = notifs.get_children()[0]
		notifs.remove_child(first)
		first.queue_free()
	var new_notif = preload("notification.tscn").instance()
	new_notif.set_text(text)
	notifs.add_child(new_notif)

func handle_return_action():
	if active_panel:
		sidebar.get_node(active_panel).handle_return_action()

##################
##   Auto-save  ##
##################

var mutex_save_level = Mutex.new()
func save_level(data = null):
	if level_file_path:
		mutex_save_level.lock()
		if data == null:
			data = board.save()
		save_manager.save_to(level_file_path, data)
		mutex_save_level.unlock()

var SAVE_INTERVAL = Globals.get("levels/editor_autosave_time_interval")
var time_to_next_save = SAVE_INTERVAL
var is_save_thread_active = false
var save_thread
var last_saved_hash = null

func process_auto_save(delta):
	if not is_save_thread_active:
		time_to_next_save -= delta
		if time_to_next_save < 0:
			is_save_thread_active = true
			if save_thread.is_active():
				save_thread.wait_to_finish()
			var save_data = board.save()
			save_thread.start(self, "auto_save", save_data, Thread.PRIORITY_LOW)
			time_to_next_save = SAVE_INTERVAL

func auto_save(data):
	var hash_val = data.hash()
	if last_saved_hash != hash_val:
		save_level(data)
		last_saved_hash = hash_val
	is_save_thread_active = false

func _exit_tree():
	if save_thread.is_active():
		save_thread.wait_to_finish()