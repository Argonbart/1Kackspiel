extends Node


var GAME_OVER_SCENE_PATH = "res://scenes/game_over_screen.tscn"
var GAME_SCENE_PATH = "res://scenes/world.tscn"
var GAME_WON_SCENE_PATH = "res://scenes/score_screen.tscn"


func game_won():
	Globals.hide_ui.emit()
	SceneSwitcher.switch_scene(GAME_WON_SCENE_PATH)


func game_over():
	Globals.hide_ui.emit()
	SceneSwitcher.switch_scene(GAME_OVER_SCENE_PATH)


func restart():
	SceneSwitcher.switch_scene(GAME_SCENE_PATH)
