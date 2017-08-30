extends Camera2D

export var margin_size = 0.2
var root

func ready():
	root = get_parent()

func change_parent(new_parent):
	self.get_parent().remove_child(self)
	new_parent.add_child(self)