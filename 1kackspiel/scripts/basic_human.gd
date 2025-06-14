extends CharacterBody2D

@onready var left_hand_point := $LeftHandPoint
@onready var right_hand_point := $RightHandPoint

@export var life = 1;
@export var umbrella_scene: PackedScene
@export var hotdog_scene: PackedScene

var movement_direction: bool = true
var random_number:int = randi_range(-5, 5) % 100
var lefthand_item
var righthand_item

func _ready() -> void:
	
	if (randf() <= 0.8) && (randf() > 0.1):
		spawn_lefthand(umbrella_scene)
	if randf() < 0.1:
		print("spawn net")
		
	if randf() <= 0.8:
		spawn_righthand(hotdog_scene)
		

func _physics_process(_delta) -> void: 
	
	
	if random_number > 0:
		$AnimatedSprite2D.flip_h = true
		move_and_collide(Vector2(-2, 0))
		if lefthand_item:
			left_hand_point.position.x = -60
		if righthand_item:
			right_hand_point.position.x = -60
	else:
		$AnimatedSprite2D.flip_h = false
		move_and_collide(Vector2(2, 0))
		if lefthand_item:
			left_hand_point.position.x = 40
		if righthand_item:
			right_hand_point.position.x = 40

func _on_timer_change_direction_timeout() -> void:
	#randomisierte Nummer für zufälligen Richtungswechsel 
	random_number = randi_range(-5, 5) % 100
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PoopArea":
		if life > 0:
			life -= 1
			if life <= 0:
				queue_free()
		
		
func spawn_lefthand(item):
	lefthand_item = item.instantiate()
	#lefthand_item.scale = Vector2(0.18, 0.18)
	lefthand_item.position = Vector2.ZERO
	left_hand_point.add_child(lefthand_item)
	
	
func spawn_righthand(item):
	righthand_item = item.instantiate()
	#righthand_item.scale = Vector2(0.18, 0.18)
	righthand_item.position = Vector2.ZERO
	right_hand_point.add_child(righthand_item)
		
#func spawn_umbrella():
	#umbrella = umbrella_scene.instantiate()
	#umbrella.scale = Vector2(0.18, 0.18)
	#umbrella.position = Vector2.ZERO
	#left_hand_point.add_child(umbrella)
	
