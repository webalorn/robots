extends "tile_config.gd"

func _ready():
	display_state()

func display_state():
	get_node("state_selected").set_hidden(tile.robot_id == null)
	if tile.robot_id != null:
		get_node("state").set_text(tr("SELECTED_ROBOT"))
		var ROBOTS_CLASS = preload("res://engine/robot.gd")
		get_node("state_selected/robot").set_texture(ROBOTS_CLASS.get_robot_icon(tile.robot_id))
		get_node("state_selected/name").set_text(str(tile.robot_id))
	else:
		get_node("state").set_text(tr("NO_ROBOT_SELECTED"))

func _on_robot_selected(robot_id):
	if robot_id != tile.robot_id:
		tile.robot_id = robot_id
		display_state()
		add_step()