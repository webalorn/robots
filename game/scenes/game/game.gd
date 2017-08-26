extends Control

func _ready():
	var board = get_node("board")
	board.width = 10
	board.height = 8
	board.add_new_robot(1, 1, 1)
	board.add_new_robot(3, 5, 2)

func scene_init(params):
	print("Game init with params: ", params)