extends Sprite

var lig
var col
const CONSTS = preload("res://engine/consts.gd")
var robot_id = 1
var root = null

func set_sprite_pos_size():
	var tile_size = root.tile_size
	set_pos(Vector2(col*tile_size + tile_size/2, lig*tile_size + tile_size / 2))
	var t = get_texture()
	var scale = Vector2(tile_size / float(t.get_height()), tile_size / float(t.get_width()))
	set_scale(scale)

func _ready():
	root = get_parent().get_parent()
	set_texture(load("res://scenes/game/robots/robot_" + str(robot_id) + ".png"))
	set_sprite_pos_size()
	
func custom_init(_lig, _col, _robot_id):
	lig = _lig
	col = _col
	robot_id = _robot_id