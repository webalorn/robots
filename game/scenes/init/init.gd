extends Control

func _ready():
	global.goto_scene("main_menu", {loading_screen = "res://splash_screen.png"})