extends Area2D

# variables for hovering
var time_passed: float = 0.0
var hovering_amplitude: float = 5.0
var hovering_speed: float = 7


# Hat hovering effect
func _process(delta):
	time_passed += delta
	position.y = sin(hovering_speed * time_passed) * hovering_amplitude


# hat hit
func _on_area_entered(area: Area2D) -> void:
	if area.get_groups().has("poop"):
		SoundManager.play_sound.emit("umbrella_destroyed")
		area.get_parent().explode_on_impact()
