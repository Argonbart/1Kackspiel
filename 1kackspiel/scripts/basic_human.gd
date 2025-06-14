extends CharacterBody2D


@export var life = 1;


var movement_direction: bool = true
var random_number:int = randi_range(-5, 5) % 100
var collision

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
		
