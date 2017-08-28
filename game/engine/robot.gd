extends "game_element.gd"

var robot_id = 1
var destroyed = false setget set_destroyed
signal signal_action_end

func set_destroyed(val):
	if val:
		set_hidden(true)
		destroyed = true

####################
##    Actions     ##
###################

func action_move(params):
	view.get_node("moves_anims").play("robot_move")
	yield(view.get_node("moves_anims"), "finished")
	line = params.to_cell.line
	col = params.to_cell.col
	set_sprite_pos_size()
	emit_signal("signal_action_end")

func action_blocked(params):
	emit_signal("signal_action_end")

func action_destroyed(params):
	self.destroyed = true
	emit_signal("signal_action_end")

func action_lost_in_space(params):
	self.destroyed = true
	emit_signal("signal_action_end")

func action_teleport(params):
	line = params.teleport_to.line
	col = params.teleport_to.col
	set_sprite_pos_size()
	emit_signal("signal_action_end")

func action_portal_blocked(params):
	print("Can't teleport")
	emit_signal("signal_action_end")

####################
##     Init       ##
####################

func _create_view():
	view = preload("res://engine/robot.tscn").instance()
	view.set_texture(load("res://scenes/game/robots/robot_" + str(robot_id) + ".png"))
	
func _init(_line, _col, _robot_id).(_line, _col):
	robot_id = _robot_id

func save():
	return {}