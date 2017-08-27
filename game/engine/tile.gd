extends Sprite

var lig
var col
var rotation = 0 setget set_rotation
const CONSTS = preload("res://engine/consts.gd")
var tile_type = null
var root = null

func set_sprite_pos_size():
	var tile_size = root.tile_size
	set_pos(Vector2(col*tile_size + tile_size/2, lig*tile_size + tile_size / 2))
	var t = get_texture()
	var scale = Vector2(tile_size / float(t.get_height()), tile_size / float(t.get_width()))
	set_scale(scale)

func set_rotation(value):
	rotation = int(value)%4;
	set_rot(float(rotation) * 2 * PI /4)

func _ready():
	root = get_parent().get_parent()
	set_texture(load("res://scenes/game/tiles/" + tile_type + ".png"))
	set_sprite_pos_size()
	
func _init(_lig, _col):
	lig = _lig
	col = _col
	
func close_propertie(): # Used to convert tiles: unlink portal, set activated
	pass
	
func get_entering_result(direction):
	return {action = CONSTS.destroyed}
	
static func createTile(type, lig, col):
	var tileClass = load("res://engine/tiles/" + type + "_tile.gd")
	var tile = tileClass.new(lig, col)
	tile.tile_type = type
	return tile