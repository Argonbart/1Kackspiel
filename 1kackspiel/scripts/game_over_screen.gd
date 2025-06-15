extends Control

@export var game_over_sprite : Sprite2D

func _ready():
	var screen_size = get_viewport_rect().size
	game_over_sprite.position.x = screen_size.x / 2
	var world = get_tree().current_scene
	world.get_node("UI").hide()


func _on_reset_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	queue_free() 
