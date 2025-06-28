extends Node2D


# nodes
@export var highscore_vbox: VBoxContainer

# variables
var save_file: Highscore


func _ready() -> void:
	save_file = load(str(OS.get_user_data_dir(), "/scores/highscore_data.tres"))


func load_score():
	for i in range(save_file.scores.size()):
		highscore_vbox.get_child(i).get_child(0).get_child(1).text = save_file.scores[i][0]
		highscore_vbox.get_child(i).get_child(0).get_child(2).text = str(save_file.scores[i][1])
