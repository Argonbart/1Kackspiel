extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if area.get_groups().has("bird"):
		GameStateManager.game_over()
