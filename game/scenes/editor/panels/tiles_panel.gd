extends "editor_panel.gd"

var active setget set_active_type
var area_first_tile = null
var area_markers_grid = null

func is_area_selection_active():
	return area_first_tile != null

func quit_area_selection_mode():
	clear_grid()
	area_first_tile = null

func set_tile_on(line, col):
	if active:
		var TYPE_CLASS = board.TILE_CLASS.get_type_class(active.type)
		if board.robot_on_cell(line, col):
			if not TYPE_CLASS.is_always_safe_for_robot():
				editor.notify(tr("TILE_CANT_BE_PLACED_UNDER_ROBOT"))
				return
		var tile = board.set_tile_type(line, col, active.type)
		return tile

func action_on_cell(line, col):
	if is_area_selection_active():
		if area_markers_grid[line][col] == null:
			quit_area_selection_mode()
		else:
			for l in range(area_markers_grid.size()):
				for c in range(area_markers_grid[l].size()):
					if area_markers_grid[l][c] != null:
						area_markers_grid[l][c].queue_free()
						set_tile_on(l, c)
						create_marker_at(l, c)
			editor.add_step()
	else:
		if set_tile_on(line, col) != null:
			editor.add_step()

func clear_grid():
	if area_markers_grid != null:
		for line in area_markers_grid:
			for col in range(line.size()):
				if line[col] != null:
					line[col].queue_free()
					line[col] = null

func recreate_grid():
	if area_markers_grid != null:
		for l in range(area_markers_grid.size()):
			for c in range(area_markers_grid[l].size()):
				if area_markers_grid[l][c] != null:
					create_marker_at(l, c)

func create_marker_at(line, col):
		var marker = load("res://scenes/editor/panels/elements/area_tile_marker.tscn").instance()
		board.grid[line][col].add_child(marker)
		area_markers_grid[line][col] = marker

func is_large_area_selected():
	var nb = 0
	if area_markers_grid != null:
		for l in range(area_markers_grid.size()):
			for c in range(area_markers_grid[l].size()):
				if area_markers_grid[l][c] != null:
					nb += 1
					if nb > 1:
						return true
	return false

func action_on_cell_long_touch(line_touch, col_touch):
	# If area_first_tile not created, create it at the size of the grid
	if area_markers_grid == null:
		area_markers_grid = []
		for line in board.grid:
			area_markers_grid.append([])
			for col in line:
				area_markers_grid[-1].append(null)
	
	# If multiple cells are selected, select only one (the first of a nex area)
	if is_large_area_selected():
		area_first_tile = null
	
	# Remove old markers
	clear_grid()
	
	# Second tile location
	var second_tile = {line = line_touch, col = col_touch}
	if area_first_tile == null:
		area_first_tile = second_tile
	
	# Create all markers
	for line in range(min(area_first_tile.line, second_tile.line),
					  max(area_first_tile.line, second_tile.line)+1):
		for col in range(min(area_first_tile.col, second_tile.col),
					     max(area_first_tile.col, second_tile.col)+1):
			create_marker_at(line, col)
	area_first_tile = second_tile

func on_hide_panel():
	quit_area_selection_mode()

func on_undo_action(datas):
	recreate_grid()

func set_active_type(type):
	if active:
		active.set_active(false)
		active = null
	if type:
		active = type
		active.set_active(true)