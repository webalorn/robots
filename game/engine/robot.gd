extends Sprite

var line
var col
const CONSTS = preload("res://engine/consts.gd")
var robot_id = 1
var root = null
var destroyed = false setget set_destroyed
signal signal_action_end

func set_destroyed(val):
	if val:
		set_hidden(true)
		destroyed = true

func set_sprite_pos_size():
	var tile_size = root.tile_size
	set_pos(Vector2(col*tile_size + tile_size/2, line*tile_size + tile_size / 2))
	var t = get_texture()
	var scale = Vector2(tile_size / float(t.get_height()), tile_size / float(t.get_width()))
	set_scale(scale)

####################
##    Actions     ##
###################

func action_move(params):
	get_node("moves_anims").play("robot_move")
	yield(get_node("moves_anims"), "finished")
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

####################
##     Init       ##
####################

func _ready():
	root = get_parent().get_parent()
	set_texture(load("res://scenes/game/robots/robot_" + str(robot_id) + ".png"))
	set_sprite_pos_size()
	
func custom_init(_line, _col, _robot_id):
	line = _line
	col = _col
	robot_id = _robot_id