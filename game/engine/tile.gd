extends "game_element.gd"

var rotation = 0 setget set_rotation
var tile_type = null

func _on_board_ready():
	set_view_active()

func set_rotation(value):
	rotation = (int(value)%4+4)%4;
	set_rot(float(rotation) * 2 * PI /4)

func has_rotation():
	return false

func is_active():
	return true if not self.has_method("set_active") else self.active

func set_is_active(value):
	if self.has_method("set_active"):
		self.active = value

func get_entering_result(direction):
	if is_safe_for_robot(): # So a robot can enter without problem
		return {action = CONSTS.move}
	return {action = CONSTS.blocked}

func get_projectile_entering_result(direction, type):
	return {result = CONSTS.result_continue}

func is_safe_for_robot():
	return is_always_safe_for_robot()

func is_robot_teleportation_possible():
	return is_safe_for_robot()

func on_teleportation_effect(robot):
	pass

func _create_view():
	var scene_path = "res://scenes/game/tiles/" + tile_type + "/" + tile_type + ".tscn"
	view = load(scene_path).instance()
	._create_view()

func _init(_line, _col, type).(_line, _col):
	tile_type = type

func change_type(type):
	return root.set_tile_type(line, col, type)

func close_properties(): # Used to convert tiles: unlink portal, remove references...
	pass

func convert_from(old_tile):
	if has_rotation():
		self.rotation = old_tile.rotation
	if has_method("set_active") and old_tile.has_method("set_active"):
		set_active(old_tile.active)

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

static func is_always_safe_for_robot():
	return false

static func get_type_class(type):
	return load("res://engine/tiles/" + type + "_tile.gd")

static func createTile(type, line, col):
	var tileClass = get_type_class(type)
	var tile = tileClass.new(line, col, type)
	return tile

static func get_tile_icon_texture(type):
	return load("res://scenes/game/tiles/" + type + "/" + type + ".png")

##################
##  Animations  ##
##################

func set_anim(anim):
	if not view:
		yield(self, "view_ready")
	if anim != view.get_animation():
		view.set_animation(anim)

func set_view_active(force_state = null):
	if self.has_method("set_active"):
		if (self.active and force_state == null) or force_state == true:
			set_anim("active")
		else:
			set_anim("inactive")