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
		area.get_parent().get_parent().queue_free() 	# poop despawned
