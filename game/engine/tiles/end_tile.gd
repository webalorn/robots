extends "../tile.gd"

onready var board = get_parent().get_parent()
var door_active = false
var robot_id = null

func _init(a, b, c).(a, b, c):
	pass

func get_entering_result(direction):
	return {action = CONSTS.move}

func _ready():
	board.register_door(self)

func _exit_tree():
	board.unregister_door(self)

func robot_enter(robot):
	if robot_id == null or robot.robot_id == robot_id:
		set_door_state(true)

func robot_exit(robot):
	if door_active:
		set_door_state(false)

func set_door_state(state):
	door_active = state

func save():
	var s = .save()
	if robot_id:
		s.robot_id = robot_id
	return s

func _load(s):
	._load(s)
	if s.has("robot_id"):
		robot_id = s.robot_id