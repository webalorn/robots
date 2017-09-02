extends Panel

func set_text(text):
	get_node("text").set_text(text)

func start_to_hide():
	get_node("anim").play("hide")
	get_node("anim").connect("finished", self, "queue_free")