extends Area2D

# variables for hovering
var time_passed: float = 0.0
var hovering_amplitude: float = 10.0
var hovering_speed: float = 7.3


# umbrella hovering effect
func _process(delta):
	time_passed += delta
	position.y = sin(hovering_speed * time_passed) * hovering_amplitude


# umbrealla hit
func _on_area_entered(area: Area2D) -> void:
	if area.name == "PoopArea":
		SoundManager.play_sound.emit("umbrella_destroyed")
		if area.get_groups().has("chestnut"):
			area.get_parent().get_parent().shoot_projectiles()
			visible = false
			await get_tree().create_timer(10.0).timeout
		if area.get_groups().has("ice"):
			#await get_tree().create_timer(1.0).timeout
			var new_poop = area.get_parent().get_parent()
			if new_poop:
				new_poop.explode()
				await get_tree().create_timer(1.0).timeout
		area.get_parent().get_parent().queue_free() 	# poop despawned
