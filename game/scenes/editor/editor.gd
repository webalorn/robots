extends Control

var level_file_path

var game_view
var board
var sidebar
var camera
var input_manager

var active_panel
const MAX_NOTIFS = 3

func _ready():
	sidebar = get_node("gui/sidebar")
	game_view = get_node("gui/level/view")
	board = game_view.get_node("board")
	camera = board.get_node("camera")
	input_manager = preload("res://scenes/editor/editor_input_manager.gd").new(self)
	
	camera.zoom_min *= 2
	game_view.add_child(input_manager)
	load_level_gameboard()
	camera.set_pos(Vector2(board.width * board.tile_size, board.height * board.tile_size)/2)
	
	# Sidebar
	show_panel("main")
	
func load_level_gameboard():
	board.load_from(save_manager.read(level_file_path))

func scene_init(params):
	level_file_path = params.level

func exit():
	global.goto_scene("main_menu")

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

func show_popup(name):
	get_node("popups/background").popup()
	get_node("popups/" + name).popup()
	get_node("gui").center_elements()

func notify(text):
	var notifs = get_node("gui/notifications")
	if notifs.get_children().size() >= MAX_NOTIFS:
		var first = notifs.get_children()[0]
		notifs.remove_child(first)
		first.queue_free()
	var new_notif = preload("notification.tscn").instance()
	new_notif.set_text(text)
	notifs.add_child(new_notif)

func _notification(what):
	if OS.get_name() == "Android" and global.is_android_return(what):
		if active_panel:
			sidebar.get_node(active_panel).handle_return_action()