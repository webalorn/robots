extends PopupPanel

export(String) var title_text = ""

signal name_set

var levels_path = Globals.get("levels/editor_store_path")
var levels_extension = Globals.get("levels/extension")

var base_name = null

const min_size = 1
const max_size = 40

func gen_new_name():
	var append = ""
	var n_append = 0
	while does_level_exist(tr("FILE_NAME_NEW_LEVEL") + append):
		n_append += 1
		append = "_" + str(n_append)
	return tr("FILE_NAME_NEW_LEVEL") + append

func get_invalids_characters(name):
	var allow = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_- !()@"
	var invalids = ""
	for c in name:
		if not c in allow:
			if not c in invalids:
				invalids += c
	return invalids

func _ready():
	get_node("title").set_text(tr(title_text))

func init_before_popup(base_name_value):
	if base_name_value:
		base_name = base_name_value
		get_node("name").set_text(base_name_value)
		get_node("rename").set_text(tr("RENAME"))
	else:
		base_name = null
		get_node("name").set_text(gen_new_name())
		get_node("rename").set_text(tr("CREATE"))
	get_node("error").set_hidden(true)

func does_level_exist(name):
	var f = File.new()
	return f.file_exists(levels_path + "/" + name + levels_extension)

func _on_cancel():
	hide()

func set_error(error):
	get_node("error").set_text(tr(error))
	get_node("error").set_hidden(false)

func _on_rename():
	var name = get_node("name").get_text()
	if name.length() < min_size:
		set_error("ERROR_NAME_TOO_SHORT")
	elif name.length() > max_size:
		set_error("ERROR_NAME_TOO_LONG")
	elif get_invalids_characters(name) != "":
		set_error(tr("ERROR_INVALID_CHARACTERS") + " : " + get_invalids_characters(name))
	elif name == base_name: # Do not change the name
		hide()
	elif does_level_exist(name):
		set_error("ERROR_NAME_ALREADY_TAKEN")
	else:
		hide()
		emit_signal("name_set", name)

func _on_name_text_changed(text):
	get_node("error").set_hidden(true)
