extends Area2D


func take_damage(_damage):
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.get_groups().has("poop"):
		SoundManager.play_sound.emit("umbrella_destroyed")
