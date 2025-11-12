extends Node2D


# nodes
@export var highscore_vbox: VBoxContainer

# variables
var save_file: Highscore


func _ready() -> void:
	
	# Make sure scores folder exists in user data folder
	var score_folder: String = str(OS.get_user_data_dir(), "/scores/")
	if not DirAccess.dir_exists_absolute(score_folder):
		DirAccess.make_dir_recursive_absolute(score_folder)
	
	# Make sure highscore file exists
	var score_file: String = str(OS.get_user_data_dir(), "/scores/highscore_data.tres")
	if not FileAccess.file_exists(score_file):
		save_file = Highscore.new()
		save_file.scores = [['AAA', 0], ['AAA', 0], ['AAA', 0], ['AAA', 0], ['AAA', 0], ['AAA', 0], ['AAA', 0], ['AAA', 0], ['AAA', 0], ['AAA', 0]]
		save_file.reset_scores()
	
	save_file = load(str(OS.get_user_data_dir(), "/scores/highscore_data.tres"))


func load_score():
	for i in range(save_file.scores.size()):
		highscore_vbox.get_child(i).get_child(0).get_child(1).text = save_file.scores[i][0]
		highscore_vbox.get_child(i).get_child(0).get_child(2).text = str(save_file.scores[i][1])
