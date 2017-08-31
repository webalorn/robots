extends "game_element.gd"

var robot_id = 1
var destroyed = false setget set_destroyed
var anim_node
signal signal_action_end

func set_destroyed(val):
	if val:
		set_hidden(true)
		destroyed = true

func play_anim(name):
	anim_node.play(name)
	yield(anim_node, "finished")
	anim_node.play(name)
	anim_node.seek(0, true)
	anim_node.stop(true)

####################
##    Actions     ##
###################

func action_move(params):
	play_anim("robot_move")
	yield(anim_node, "finished")
	
	line = params.to_cell.line
	col = params.to_cell.col
	set_sprite_pos_size()
	emit_signal("signal_action_end")

func action_blocked(params):
	return null
	emit_signal("signal_action_end")

func action_destroyed(params):
	play_anim("robot_dead")
	yield(anim_node, "finished")
	
	self.destroyed = true
	emit_signal("signal_action_end")

func action_lost_in_space(params):
	play_anim("robot_dead")
	yield(anim_node, "finished")
	
	self.destroyed = true
	emit_signal("signal_action_end")

func action_teleport(params):
	play_anim("robot_teleport")
	yield(anim_node, "finished")
	
	line = params.teleport_to.line
	col = params.teleport_to.col
	set_sprite_pos_size()
	emit_signal("signal_action_end")

func action_portal_blocked(params):
	print("Can't teleport")
	emit_signal("signal_action_end")

####################
##      GUI       ##
####################

var gui_childs = ["arrows"]

func hide_gui():
	for k in gui_childs:
		view.get_node(k).set_hidden(true)

func show_gui(element_name):
	hide_gui()
	view.get_node(element_name).set_hidden(false)

func get_active_gui():
	for k in gui_childs:
		if not view.get_node(k).is_hidden():
			return k

####################
##     Init       ##
####################

func _create_view():
	view = preload("res://engine/robot.tscn").instance()
	view.set_texture(load("res://scenes/game/robots/robot_" + str(robot_id) + ".png"))
	anim_node = view.get_node("moves_anims")
	hide_gui()
	
func _init(_line, _col, _robot_id).(_line, _col):
	robot_id = _robot_id

func save():
	var s = .save()
	s.robot_id = robot_id
	s.destroyed = destroyed
	return s
	
func _load(s):
	._load(s)
	destroyed = s.destroyed
	
static func load_from(s):
	var robot = new(s.line, s.col, s.robot_id)
	robot._load(s)
	return robot