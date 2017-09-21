extends "../tile.gd"

var portal_id = null setget set_portal_id
const PORTAL_CLASS = preload("portal_tile.gd")
const portal_colors = {
	1 : "green",
	2 : "orange"
}

func has_rotation():
	return true

func get_portal_color():
	if portal_id == null:
		return "white"
	return portal_colors[portal_id]

func display_state():
	if view:
		var p = view.get_node("portal")
		if portal_id == null:
			p.set_hidden(true)
		else:
			p.set_hidden(false)
			p.set_modulate(CONSTS.color_to_modulate[get_portal_color()])

func set_portal_id(value):
	if value != portal_id:
		if portal_id != null:
			root.robot_portals.erase(portal_id)
		portal_id = value
		if portal_id != null:
			root.add_robot_portal(self)
	display_state()

func get_portal_out_tile():
	return PORTAL_CLASS.get_portal_out_tile_from(self)

func get_entering_result(direction):
	if portal_id != null and direction == CONSTS.DIRS.UP:
		var linked_to = root.get_linked_robot_portal(portal_id)
		return PORTAL_CLASS.get_entering_special_action_from(self, linked_to)
	return {action = CONSTS.blocked}

func get_projectile_entering_result(direction, type):
	if type == CONSTS.projectile_portal:
		return {result = CONSTS.result_target_reached}
	return {result = CONSTS.result_blocked}

func _init(a, b, c).(a, b, c):
	pass

func _ready():
	display_state()

func save():
	var s = .save()
	if portal_id != null:
		s.portal_id = portal_id
	return s
	
func load_refs_from(s):
	if s.has("portal_id"):
		set_portal_id(int(s.portal_id))