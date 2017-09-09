extends Node2D

var view = null
var line
var col
var root = null

func set_sprite_pos_size():
	var tile_size = root.tile_size
	set_pos(Vector2(col*tile_size + tile_size/2, line*tile_size + tile_size / 2))
	var texture_size = 256.0
	set_scale(Vector2(tile_size / texture_size, tile_size / texture_size)) # Assuming that all tiles, texture are 256*256

func get_coords():
	return Vector2(line, col)

func _create_view():
	pass

func _ready():
	root = get_parent().get_parent()
	_create_view()
	add_child(view)
	set_sprite_pos_size()

func _init(_line, _col):
	line = _line
	col = _col

func save():
	return {
		line = line,
		col = col
	}

func _load(s):
	pass