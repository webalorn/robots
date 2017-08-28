extends Node

enum DIRS {UP = 0, LEFT = 1, DOWN = 2, RIGHT = 3}

const blocked = "blocked"
const move = "move"
const lost_in_space = "lost_in_space"
const destroyed = "destroyed"
const teleport = "teleport"
const portal_blocked = "portal_blocked"

func invertDir(dir):
	if dir == DIRS.UP:
		return DIRS.DOWN
	if dir == DIRS.DOWN:
		return DIRS.UP
	if dir == DIRS.LEFT:
		return DIRS.RIGHT
	return DIRS.LEFT

func real_side(tileSide, tileRotation):
	return (tileSide + 4 - tileRotation)%4
	
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