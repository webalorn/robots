extends "special_tile.gd"

var linked_to = null setget link_to
var FLOOR_CLASS = preload("res://engine/tiles/floor_tile.gd")

func _init(a, b, c).(a, b, c):
	pass

func unlink():
	if linked_to:
		linked_to.linked_to = null
		linked_to = null

func link_to(portal):
	if not linked_to and portal.linked_to == self:
		linked_to = portal
	else:
		self.unlink()
		portal.unlink()
		linked_to = portal
		portal.linked_to = self

func close_propertie():
	unlink()
	.close_properties()

func get_portal_out_tile():
	var next_pos = CONSTS.apply_move(line, col, rotation)
	if not root.pos_in_grid(next_pos.line, next_pos.col):
		return null
	var tile = root.grid[next_pos.line][next_pos.col]
	if not tile extends FLOOR_CLASS:
		return null
	return tile

func get_entering_special_action():
	if !linked_to or not linked_to.has_method("get_portal_out_tile"):
		return {action = CONSTS.blocked}
	var next_tile = linked_to.get_portal_out_tile()
	if not next_tile:
		return {action = CONSTS.portal_blocked, portals = [self, linked_to]}
	return {
		action = CONSTS.teleport,
		teleport_to = next_tile,
		direction = linked_to.rotation
	}