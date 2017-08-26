extends Reference

enum DIRS {UP = 0, LEFT = 1, DOWN = 2, RIGHT = 3}

static func invertDir(dir):
	if dir == DIRS.UP:
		return DIRS.DOWN
	if dir == DIRS.DOWN:
		return DIRS.UP
	if dir == DIRS.LEFT:
		return DIRS.RIGHT
	return DIRS.LEFT

static func real_side(tileSide, tileRotation):
	return (tileSide + 4 - tileRotation)%4