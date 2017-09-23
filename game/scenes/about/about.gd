extends "res://scenes/base_scene.gd"

func exit():
	global.goto_scene("config")

func _on_godot_button_pressed():
	OS.shell_open("http://godotengine.org")