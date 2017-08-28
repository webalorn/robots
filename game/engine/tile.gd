extends "game_element.gd"

var rotation = 0 setget set_rotation
var tile_type = null

func set_rotation(value):
	rotation = int(value)%4;
	set_rot(float(rotation) * 2 * PI /4)
	
func get_entering_result(direction):
	return {action = CONSTS.destroyed}

func _create_view():
	view = Sprite.new()
	view.set_texture(load("res://scenes/game/tiles/" + tile_type + ".png"))
	
func _init(_line, _col, type).(_line, _col):
	tile_type = type

func change_type(type):
	return root.set_tile_type(line, col, type)

func close_propertie(): # Used to convert tiles: unlink portal, remove references...
	pass

func save():
	var s = .save()
	s.tile_type = tile_type
	s.rotation = rotation
	return s
	
func _load(s):
	._load(s)
	rotation = s.rotation
	
static func load_from(s):
	var tile = createTile(s.tile_type, s.line, s.col)
	tile._load(s)
	return tile

static func createTile(type, line, col):
	var tileClass = load("res://engine/tiles/" + type + "_tile.gd")
	var tile = tileClass.new(line, col, type)
	return tile