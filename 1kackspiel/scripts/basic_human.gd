extends CharacterBody2D


# constants
const _PICK_UP_SCENE = preload("res://scenes/pick_up.tscn")

# local nodes
@export var human_sprite: AnimatedSprite2D
@export var left_hand_point: Node2D
@export var right_hand_point: Node2D

# external scenes (left hand)
@export var umbrella_scene: PackedScene
@export var net_scene: PackedScene

# balance variables
@export var life_points: int = 1;
@export var human_moving_speed: float = 1.0

# pick ups (right hand)
@export var pick_up_list: Array[PickUp]

#variables
var random_number: int = randi_range(0, 1)
var lefthand_item
var righthand_item


func _ready() -> void:
	
	add_random_pickup()
	
	if umbrella_condition():
		spawn_lefthand(umbrella_scene)
	if net_condition():
		spawn_lefthand(net_scene)


func umbrella_condition():
	return (randf() <= 0.8) && (randf() > 0.1)


func net_condition():
	return randf() < 1


func _physics_process(_delta) -> void: 
	
	# flip human
	human_sprite.flip_h = random_number == 0
	
	# move human
	move_and_collide(Vector2(pow(-1, int(human_sprite.flip_h)) * human_moving_speed, 0))
	
	# flip left hand
	if lefthand_item:
		lefthand_item.scale.x = 0.2 * pow(-1, int(human_sprite.flip_h)) # mirror on x-axis
		left_hand_point.position.x = 40 - int(human_sprite.flip_h) * 100
		
	# flip right hand
	if righthand_item:
		right_hand_point.position.x = 40 - int(human_sprite.flip_h) * 100


func _on_timer_change_direction_timeout() -> void:
	#randomisierte Nummer für zufälligen Richtungswechsel 
	random_number = randi_range(0, 1)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PoopArea": 						# poop trifft mensch
		area.get_parent().get_parent().queue_free() 	# poop despawned
		life_points -= 1								# mensch bekommt schaden
		if life_points <= 0:
			queue_free()


func spawn_lefthand(item):
	lefthand_item = item.instantiate()
	left_hand_point.add_child(lefthand_item)


func spawn_righthand(item):
	righthand_item = item.instantiate()
	right_hand_point.add_child(righthand_item)


func add_random_pickup():
	var new_pick_up = _PICK_UP_SCENE.instantiate()
	new_pick_up.pick_up_resource = pick_up_list[randi_range(0, 1)]
	right_hand_point.add_child(new_pick_up)
	righthand_item = new_pick_up
