@tool
extends EditorPlugin

const PLUGIN_NAME := "QuitButton"

const PLUGIN_ICON := preload("res://addons/quit_button/quit_button.svg")

func _get_plugin_name() -> String:
	return PLUGIN_NAME

func _get_plugin_icon() -> Texture2D:
	return PLUGIN_ICON
