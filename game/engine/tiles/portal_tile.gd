extends "special_tile.gd"

var linked_to = null setget link_to
const FLOOR_CLASS = preload("res://engine/tiles/floor_tile.gd")
var active = true setget set_active

func _init(a, b, c).(a, b, c):
	pass

func has_rotation():
	return true

func save():
	var s = .save()
	if linked_to:
		s.linked_to = {line = linked_to.line, col = linked_to.col}
	return s

func load_refs_from(s):
	if s.has("linked_to"):
		link_to(root.grid[s.linked_to.line][s.linked_to.col])

func set_active(value):
	value = true if value else false
	active = value
	if linked_to and linked_to.active != active:
		linked_to.active = active
	set_view_active()

func set_view_active(force_state = null):
	if linked_to == null and root and root.game_active():
		.set_view_active(false)
	else:
		.set_view_active(force_state)

func unlink():
	if linked_to:
		var portal = linked_to
		linked_to = null
		if portal:
			portal.linked_to = null

func link_to(portal):
	if portal == self:
		return
	if portal == null:
		unlink()
		return
	if linked_to == portal:
		return
	if not linked_to and portal.linked_to == self:
		linked_to = portal
	else:
		self.unlink()
		portal.unlink()
		linked_to = portal
		portal.linked_to = self
		
		if portal.active or active:
			set_active(true)
		else:
			set_active(false)

func close_properties():
	unlink()
	.close_properties()

static func get_portal_out_tile_from(portal):
	var next_pos = CONSTS.apply_move(portal.line, portal.col, portal.rotation)
	if not portal.root.pos_in_grid(next_pos.line, next_pos.col):
		return next_pos
	var tile = portal.root.grid[next_pos.line][next_pos.col]
	if not tile.is_robot_teleportation_possible():
		return null
	if portal.root.robot_on_cell(next_pos.line, next_pos.col):
		return null
	return tile

func get_portal_out_tile():
	return get_portal_out_tile_from(self)

static func get_entering_special_action_from(portal, linked_to):
	if linked_to == null or (portal.has_method("set_active") and not portal.active):
		return {action = CONSTS.blocked}
	var next_tile = linked_to.get_portal_out_tile()
	if next_tile == null:
		return {action = CONSTS.portal_blocked, portals = [portal, linked_to]}
	return {
		action = CONSTS.teleport,
		teleport_to = next_tile,
		direction = linked_to.rotation
	}
func get_entering_special_action():
	return get_entering_special_action_from(self, linked_to)