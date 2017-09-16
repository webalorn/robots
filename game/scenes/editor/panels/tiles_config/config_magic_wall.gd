extends "tile_config.gd"

func display_color():
	get_node("center/color").set_modulate(CONSTS.color_to_modulate[tile.get_portal_color()])

func _ready():
	display_color()
	for id in tile.portal_colors:
		get_node("portals/portal" + str(id)).set_modulate(
			CONSTS.color_to_modulate[tile.portal_colors[id]]
		)

func set_portal_id(portal_id = null):
	tile.portal_id = portal_id
	add_step()
	display_color()