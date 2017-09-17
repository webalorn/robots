extends Node

enum DIRS {UP = 0, LEFT = 1, DOWN = 2, RIGHT = 3}
enum projectiles {portal = 0}

const colors = ["red", "green", "blue", "orange", "white"]
const color_to_modulate = {
	"white" : Color(1, 1, 1),
	"red" : Color(246 / 255.0, 5 / 255.0, 5 / 255.0),
	"green" : Color(5 / 255.0, 246 / 255.0, 37 / 255.0),
	"orange": Color(0.93, 0.52, 0.05)
}

##  For robots  ##
const blocked = "blocked"
const move = "move"
const lost_in_space = "lost_in_space"
const destroyed = "destroyed"
const teleport = "teleport"
const portal_blocked = "portal_blocked"

##  For projectiles  ##
const result_target_reached = "reached"
const result_blocked = "blocked"
const result_continue = "continue"
const result_out_of_grid = "out_of_grid"

func invertDir(dir):
	if dir == DIRS.UP:
		return DIRS.DOWN
	if dir == DIRS.DOWN:
		return DIRS.UP
	if dir == DIRS.LEFT:
		return DIRS.RIGHT
	return DIRS.LEFT

func real_side(tileSide, tileRotation):
	return int(tileSide + 4 - tileRotation)%4
	
func apply_move(line, col, move):
	if move == DIRS.UP:
		line -= 1
	elif move == DIRS.DOWN:
		line += 1
	elif move == DIRS.LEFT:
		col -= 1
	elif move == DIRS.RIGHT:
		col += 1
	return {"line" : line, "col" : col}

func move_to_str(move):
	if move == DIRS.UP:
		return "up"
	elif move == DIRS.DOWN:
		return "down"
	elif move == DIRS.LEFT:
		return "left"
	elif move == DIRS.RIGHT:
		return "right"
	return ""

func get_move_id_from_dists(line_dist, col_dist):
	if line_dist == -1 and col_dist == 0:
		return DIRS.UP
	elif line_dist == 1 and col_dist == 0:
		return DIRS.DOWN
	elif line_dist == 0 and col_dist == 1:
		return DIRS.RIGHT
	elif line_dist == 0 and col_dist == -1:
		return DIRS.LEFT
	return null