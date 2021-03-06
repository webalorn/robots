extends "../tile.gd"

onready var board = get_parent().get_parent()
var door_active = false
var robot_id = null setget set_robot_id

func _init(a, b, c).(a, b, c):
	pass

func _ready():
	board.register_door(self)
	set_robot_id(robot_id)

func is_safe_for_robot():
	return true

func set_robot_id(value):
	robot_id = value
	if view:
		var portal = view.get_node("portal") 
		if robot_id:
			var robot_color = board.ROBOT_CLASS.robots_colors[robot_id]
			portal.set_modulate(CONSTS.color_to_modulate[robot_color])
		else:
			portal.set_modulate(Color(1, 1, 1))

func _exit_tree():
	board.unregister_door(self)

func end_activated_by(id):
	return robot_id == null or id == robot_id

func robot_enter(robot):
	if end_activated_by(robot.robot_id):
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
		set_robot_id(s.robot_id)