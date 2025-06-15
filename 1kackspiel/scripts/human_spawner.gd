extends Node2D


@export var mob_scene: PackedScene
@export var bird: CharacterBody2D


func _on_timer_timeout() -> void:
	
	 # Sichtbereich in Pixeln
	var screen_size = get_viewport().get_visible_rect().end.x
	var spawn_position_right = bird.position.x + screen_size / 2 + 100
	var spawn_position_left = bird.position.x - screen_size / 2 - 100
	# Create a new instance of the Mob scene
	var enemy = mob_scene.instantiate()
	var enemy2 = mob_scene.instantiate()
	enemy.position = Vector2(spawn_position_right,500)
	enemy2.position = Vector2(spawn_position_left,500)
	add_child(enemy)
	add_child(enemy2)
