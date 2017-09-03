extends "tile_config.gd"

var target_mark

func remove_target_mark():
	if target_mark:
		target_mark.queue_free()
		target_mark = null

func display_state():
	get_node("state_linked").set_hidden(not tile.linked_to)
	get_node("state_unlinked").set_hidden(not not tile.linked_to)
	remove_target_mark()
	if tile.linked_to:
		target_mark = preload("res://scenes/editor/panels/elements/target_tile.tscn").instance()
		tile.linked_to.add_child(target_mark)

func _ready():
	display_state()
	display_buttons()

func _exit_tree():
	remove_target_mark()

func display_buttons():
	get_node("link").set_hidden(intercept_action)
	get_node("unlink").set_hidden(intercept_action or not tile.linked_to)
	get_node("text_action").set_hidden(not intercept_action)
	get_node("cancel").set_hidden(not intercept_action)

func _on_link_portal():
	intercept_action = true
	display_buttons()

func _on_cancel_action():
	intercept_action = false
	display_buttons()

func _on_unlink_action():
	tile.unlink()
	display_state()
	display_buttons()

func handle_action(tile_action):
	if tile_action == tile:
		panel.editor.notify("NOTIF_DONT_SELECT_SAME_PORTAL")
	elif tile_action.has_method("link_to"):
		tile_action.link_to(tile)
	else:
		panel.editor.notify("NOTIF_SELECT_A_PORTAL")
	intercept_action = false
	display_state()
	display_buttons()