extends "game_element.gd"

var rotation = 0 setget set_rotation
var tile_type = null

func set_rotation(value):
	rotation = int(value)%4;
	set_rot(float(rotation) * 2 * PI /4)

func has_rotation():
	return false

func is_active():
	return true if not self.has_method("set_active") else self.active

func set_is_active(value):
	if self.has_method("set_active"):
		self.active = value

func get_entering_result(direction):
	return {action = CONSTS.destroyed}

func _create_view():
	view = Sprite.new()
	view.set_texture(load("res://scenes/game/tiles/" + tile_type + ".png"))
	
func _init(_line, _col, type).(_line, _col):
	tile_type = type

func change_type(type):
	return root.set_tile_type(line, col, type)

func close_properties(): # Used to convert tiles: unlink portal, remove references...
	if self.has_method("set_active"):
		set_active(true)

func save():
	var s = .save()
	s.tile_type = tile_type
	s.rotation = rotation
	s.active = self.is_active()
	return s
	
func _load(s):
	._load(s)
	self.set_is_active(s.active)
	self.rotation = s.rotation
	
static func load_from(s):
	var tile = createTile(s.tile_type, s.line, s.col)
	tile._load(s)
	return tile

func load_refs_from(s): # targets, links, etc... can't be created in "_load"
	pass

static func is_safe_for_robot():
	return false

static func get_type_class(type):
	return load("res://engine/tiles/" + type + "_tile.gd")

static func createTile(type, line, col):
	var tileClass = get_type_class(type)
	var tile = tileClass.new(line, col, type)
	return tile

static func get_tile_icon_texture(type):
	return load("res://scenes/game/tiles/" + type + ".png")