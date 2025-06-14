extends CharacterBody2D


@export var life = 1;


var movement_direction: bool = true
var random_number:int = 0
var collision

func _physics_process(delta: float) -> void: 
	
	
	
	#move_and_slide()
	if random_number > 0:
		collision = move_and_collide(Vector2(-2, 0))
		
	else:
		collision = move_and_collide(Vector2(2, 0))
	

		
	#if collision:
		#var other = collision.get_collider()
		#print("Kollision mit:", other.name)
		#if other.name == "PoopBody":
			#life -= 1;
		#if life <=0:
			#queue_free()
	


func _on_timer_change_direction_timeout() -> void:
	random_number = randi_range(-5, 1) % 100
	print(random_number)


func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.name)
