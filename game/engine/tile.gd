extends Sprite

var lig
var col
var tileSize setget set_tile_size
var rotation = 0 setget set_rotation
const CONSTS = preload("res://engine/consts.gd")

func setPosAndSize():
	set_pos(Vector2(col*tileSize + tileSize/2, lig*tileSize + tileSize / 2))
	var t = get_texture()
	var scale = Vector2(tileSize / float(t.get_height()), tileSize / float(t.get_width()))
	set_scale(scale)

func set_tile_size(size):
	tileSize = size
	setPosAndSize()

func set_rotation(value):
	value = int(value)%4;
	set_rot(float(value) * 2 * PI /4)

func _ready():
	set_texture(preload("res://icon.png"))
	setPosAndSize()
	
func _init(_lig, _col, _tileSize):
	lig = _lig
	col = _col
	tileSize = _tileSize