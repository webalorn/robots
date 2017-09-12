extends "game_element.gd"

var robot_id = 1
var destroyed = false setget set_destroyed
var anim_nodes = []

const existants_ids = ["1", "2"]

####################
##   Animations   ##
####################

func get_player_of(anim_name):
	for name in anim_nodes:
		if anim_nodes[name].has_animation(anim_name):
			return anim_nodes[name]

func set_destroyed(val):
	if val:
		set_hidden(true)
		destroyed = true

func play_anim(name, type_action):
	var player = get_player_of(name)
	player.play(name)
	
	if type_action == "action":
		root.wait_action(player)
	elif type_action == "effect":
		root.wait_effect(player)
	yield(player, "finished")
	player.play(name)
	player.seek(0, true)
	player.stop(true)

func play_anim_move(direction, type = null):
	var dir = CONSTS.move_to_str(direction)
	play_anim("move_" + dir + ("_" + type if type else ""), "action")

#######################
##  ACtions effects  ##
#######################

func set_pos_from_params(params, pos_property = "to_cell"):
	line = params[pos_property].line
	col = params[pos_property].col
	set_sprite_pos_size()

###############
##  Effects  ##
###############

func effect_lost_in_space():
	if root.game_active():
		play_anim("robot_dead", "effect")
		yield(anim_nodes.effects, "finished")
		self.destroyed = true

####################
##    Actions     ##
####################

func action_move(params):
	play_anim_move(params.action_direction)
	yield(anim_nodes.moves, "finished")
	
	set_pos_from_params(params)

func action_blocked(params):
	pass

func action_destroyed(params):
	play_anim("robot_dead", "action")
	play_anim_move(params.action_direction, "slow")
	yield(anim_nodes.effects, "finished")
	
	set_pos_from_params(params)
	self.destroyed = true

func action_lost_in_space(params):
	action_destroyed(params)

func action_teleport(params):
	play_anim("robot_teleport", "action")
	yield(anim_nodes.effects, "finished")
	
	set_pos_from_params(params, "teleport_to")

func action_portal_blocked(params):
	pass

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
	anim_nodes = {
		moves = view.get_node("moves_anims"),
		effects = view.get_node("effects_anims")
	}
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

static func get_robot_icon(robot_id):
	return load("res://scenes/game/robots/robot_" + str(robot_id) + ".png")