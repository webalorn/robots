tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("StaticPopupPanel", "PopupPanel", preload("StaticPopupPanel.gd"), preload("icon.png"))

func _exit_tree():
    pass