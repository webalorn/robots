extends Node2D

var board
var rotation setget set_rotation
var id_action = 0

func set_position(line, col):
	set_pos(Vector2(col * board.tile_size + board.tile_size / 2,
		line * board.tile_size + board.tile_size / 2))

func set_rotation(value):
	rotation = (int(value)%4+4)%4;
	set_rot(float(rotation) * 2 * PI /4)

func attach(_board, robot):
	board = _board
	var scale = board.tile_size / 256.0
	self.set_scale(Vector2(board.tile_size / 256.0, board.tile_size / 256.0))
	board.add_child(self)
	set_position(0, 0)
	board.connect("board_cleared", self, "queue_free")
	board.linked_processor.connect("processing_end", self, "queue_free")
	
	set_position(robot.line, robot.col)
	get_node("projectile").set_modulate(CONSTS.color_to_modulate[robot.robots_colors[robot.robot_id]])

##################
##  Animations  ##
##################

onready var anims = get_node("anims")

func play_anim(name, keep_end_state = false):
	var player = anims
	player.play(name)
	
	board.wait_action(player)
	yield(player, "finished")
	if not keep_end_state:
		player.play(name)
		player.seek(0, true)
		player.stop(true)

func play_anim_move(direction):
	play_anim("move_" + CONSTS.move_to_str(direction))

###############
##  Actions  ##
###############

func action_continue(result):
	# play_anim_move(result.move_direction)
	play_anim("move_up")
	yield(anims, "finished")
	set_position(result.to_pos.line, result.to_pos.col)

func handle_action(result):
	set_rotation(result.move_direction)
	set_position(result.from_pos.line, result.from_pos.col)
	if id_action == 0:
		if result.result == "continue":
			play_anim("appear", true)
			set_position(result.to_pos.line, result.to_pos.col)
	else:
		if self.has_method("action_" + result.result):
			self.call("action_" + result.result, result)
	id_action += 1