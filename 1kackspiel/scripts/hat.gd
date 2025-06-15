extends Area2D

# variables for hovering
var time_passed: float = 0.0
var hovering_amplitude: float = 5.0
var hovering_speed: float = 7

# Hat hovering effect
func _process(delta):
	time_passed += delta
	position.y = sin(hovering_speed * time_passed) * hovering_amplitude
