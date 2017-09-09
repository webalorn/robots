extends Reference

var state
var changes_list = []

func reset_to(reset_state):
	state = reset_state
	changes_list = []

func _init(base_state):
	state = base_state

func get_state():
	return copy_data(state)

func add_step(new_state):
	changes_list.push_back(compute_changes(state, new_state))
	state = new_state

func revert_last_change():
	if changes_list.empty():
		return false
	var change = changes_list.back()
	changes_list.pop_back()
	state = apply_changes(change, state)
	return true

func apply_changes(changes, actual):
	if changes == false:
		return actual
	if changes.size() == 2:
		return changes[1]
	else:
		var value = changes[0]
		if typeof(value) == TYPE_ARRAY:
			for i in range(value.size()):
				if i < actual.size():
					value[i] = apply_changes(value[i], actual[i])
				else:
					value[i] = value[i][1]
		elif typeof(value) == TYPE_DICTIONARY:
			for key in value:
				if actual.has(key):
					value[key] = apply_changes(value[key], actual[key])
				else:
					value[key] = value[key][1]
		else:
			value = value[1]
		return value

#
# null -> added value (must be deleted when doing reverse operation)
# false -> no changes
# [value] -> changes
# ["set", value] -> a part of the tree was deleted
#
func compute_changes(value_current, value_next):
	var has_changes = false
	var changes
	if typeof(value_current) == TYPE_DICTIONARY and typeof(value_next) == TYPE_DICTIONARY:
		changes = {}
		for key in value_current:
			if value_next.has(key):
				changes[key] = compute_changes(value_current[key], value_next[key])
				if changes[key] != false:
					has_changes = true
			else:
				changes[key] = ["set", value_current[key]]
				has_changes = true
		for key in value_next:
			if not changes.has(key):
				has_changes = true
	elif typeof(value_current) == TYPE_ARRAY and typeof(value_next) == TYPE_ARRAY:
		changes = []
		changes.resize(value_current.size())
		if value_current.size() != value_next.size():
			has_changes = true
		var same_size = min(value_current.size(), value_next.size()) 
		for i in range(same_size):
			changes[i] = compute_changes(value_current[i], value_next[i])
			if changes[i] != false:
				has_changes = true
		for i in range(same_size, changes.size()):
			changes[i] = ["set", value_current[i]]
	else:
		if value_current != value_next:
			return ["set", value_current]
	
	if has_changes:
		return [changes]
	return false

func copy_data(data):
	var v = null
	if typeof(data) == TYPE_DICTIONARY:
		v = {}
		for key in data:
			v[key] = copy_data(data[key])
	elif typeof(data) == TYPE_ARRAY:
		v = []
		for val in data:
			v.append(copy_data(val))
	else:
		v = data
	return v