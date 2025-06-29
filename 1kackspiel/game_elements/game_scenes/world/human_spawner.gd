extends Node2D


@export var _SPAWN_POSITION_Y: float = 500.0
@export var human: PackedScene
@export var bird: Bird
@export var spawn_timer: Timer

var spawn_position_right: float = 0.0
var spawn_position_left: float = 0.0


func _process(_delta: float) -> void:
	spawn_position_right = bird.position.x + get_viewport().get_visible_rect().size.x / 2 + 100
	spawn_position_left = bird.position.x - get_viewport().get_visible_rect().size.x / 2 - 100


func spawn_human(position_x: float):
	var new_human = human.instantiate()
	new_human.position = Vector2(position_x, _SPAWN_POSITION_Y)
	add_child(new_human)


func _on_timer_timeout() -> void:
	spawn_human(spawn_position_left)
	spawn_human(spawn_position_right)
	spawn_timer.wait_time = remap(randf(), 0.0, 1.0, Parameters.SPAWN_TIMER_MINIMUM, Parameters.SPAWN_TIMER_MAXIMUM)
