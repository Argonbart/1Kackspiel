extends CharacterBody2D

@onready var umbrella_point := $UmbrellaPoint

@export var life = 1;
@export var umbrella_scene: PackedScene


var movement_direction: bool = true
var random_number:int = randi_range(-5, 5) % 100


func _ready() -> void:
	if randf() < 1:
		spawn_umbrella()




func _physics_process(_delta) -> void: 
	
	if random_number > 0:
		move_and_collide(Vector2(-2, 0))
		
	else:
		move_and_collide(Vector2(2, 0))
	

func _on_timer_change_direction_timeout() -> void:
	random_number = randi_range(-5, 5) % 100
	print(random_number)


func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.name == "PoopArea":
		if life > 0:
			life -= 1
			print("Leben verloren")
			if life <= 0:
				queue_free()
		
		
func spawn_umbrella():
	var umbrella = umbrella_scene.instantiate()
	umbrella.scale = Vector2(0.2, 0.2)
	umbrella.position = Vector2.ZERO
	umbrella_point.add_child(umbrella)
