class_name Highscore
extends Resource


@export var scores: Array


func add_new_score(new_entry: Array):
	for idx in range(0, scores.size(), 1):
		if new_entry[1] > scores[idx][1]:
			scores.insert(idx, new_entry)
			if scores.size() > 10:
				scores.remove_at(scores.size() - 1)
			break
	ResourceSaver.save(self, str(OS.get_user_data_dir(), "/scores/highscore_data.tres"))


func reset_scores():
	var new_scores: Array
	for idx in range(0, scores.size(), 1):
		new_scores.insert(idx, ["---", 0])
	scores = new_scores
	ResourceSaver.save(self, str(OS.get_user_data_dir(), "/scores/highscore_data.tres"))
