extends Node


var GAME_OVER_SCENE_PATH = "res://scenes/game_over_screen.tscn"
var GAME_SCENE_PATH = "res://scenes/world.tscn"


func game_over():
	Globals.hide_ui.emit()
	SceneSwitcher.switch_scene(GAME_OVER_SCENE_PATH)


func restart():
	SceneSwitcher.switch_scene(GAME_SCENE_PATH)
