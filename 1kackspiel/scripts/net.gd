extends Area2D


var game_over_scene = preload("res://scenes/game_over_screen.tscn")

func _on_area_entered(area: Area2D) -> void:
	if area.name == "BirdArea":
		var game_over_instance = game_over_scene.instantiate()
		add_child(game_over_instance)
		get_tree().paused = true
		
		
