extends CharacterBody2D

@onready var umbrella_point := $UmbrellaPoint

@export var life = 1;
@export var umbrella_scene: PackedScene

var movement_direction: bool = true
var random_number:int = randi_range(-5, 5) % 100
var umbrella

func _ready() -> void:
	
	if randf() < 1:
		spawn_umbrella()

func _physics_process(_delta) -> void: 
	
	if random_number > 0:
		$AnimatedSprite2D.flip_h = true
		move_and_collide(Vector2(-2, 0))
		if umbrella:
			umbrella.position.x = -60
	else:
		$AnimatedSprite2D.flip_h = false
		move_and_collide(Vector2(2, 0))
		umbrella.position.x = 60
	

func _on_timer_change_direction_timeout() -> void:
	random_number = randi_range(-5, 5) % 100
	print(random_number)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PoopArea":
		if life > 0:
			life -= 1
			if life <= 0:
				queue_free()
		
		
func spawn_umbrella():
	umbrella = umbrella_scene.instantiate()
	umbrella.scale = Vector2(0.18, 0.18)
	umbrella.position = Vector2.ZERO
	umbrella_point.add_child(umbrella)
