class_name Human
extends Node2D


# exports
@export var GENERAL_SPEED_MULTIPLIER: float = 100.0

# nodes
@export var human_sprite: AnimatedSprite2D
@export var left_hand_point: Node2D
@export var right_hand_point: Node2D
@export var head_point: Node2D

# scenes
@export var _PICK_UP_SCENE: PackedScene
@export var _HEAD_SCENE: PackedScene
@export var _UMBRELLA_SCENE: PackedScene
@export var _NET_SCENE: PackedScene

# variables
var moving_direction: bool = false # 0 = nach rechts ; 1 = nach links
var human_moving_speed: float = 1.0
var current_life_points: int = Parameters.BASIC_LIFE_POINTS


func _ready() -> void:
	
	# warning if right hand spawning chances not equal to 1.0
	if Parameters.SPAWN_CHANCE_BERRY + Parameters.SPAWN_CHANCE_FIRE + Parameters.SPAWN_CHANCE_ICE + Parameters.SPAWN_CHANCE_RIGHT_NOTHING != 1.0:
		push_warning("Human: Right hand item spawning chances do not add up to 1.0! ERROR")
	
	# random right hand item
	var random_righthand_item = randf()
	if random_righthand_item < Parameters.SPAWN_CHANCE_BERRY:
		add_pick_up(Enum.PoopType.BERRY) # spawn berries
	elif random_righthand_item < Parameters.SPAWN_CHANCE_BERRY + Parameters.SPAWN_CHANCE_FIRE:
		add_pick_up(Enum.PoopType.FIRE) # spawn hotdog
	elif random_righthand_item < Parameters.SPAWN_CHANCE_BERRY + Parameters.SPAWN_CHANCE_FIRE + Parameters.SPAWN_CHANCE_ICE:
		add_pick_up(Enum.PoopType.ICE) # spawn icecream
	
	# warning if left hand spawning chances not equal to 1.0
	if Parameters.SPAWN_CHANCE_HAT + Parameters.SPAWN_CHANCE_UMBRELLA + Parameters.SPAWN_CHANCE_NET + Parameters.SPAWN_CHANCE_LEFT_NOTHING != 1.0:
		push_warning("Human: Right hand item spawning chances do not add up to 1.0! ERROR")
	
	# random left hand item
	var random_lefthand_item = randf()
	if random_lefthand_item < Parameters.SPAWN_CHANCE_HAT:
		add_head_armor(_HEAD_SCENE) # spawn head
	elif random_lefthand_item < Parameters.SPAWN_CHANCE_HAT + Parameters.SPAWN_CHANCE_UMBRELLA:
		add_weapon(_UMBRELLA_SCENE) # spawn umbrella
	elif random_lefthand_item < Parameters.SPAWN_CHANCE_HAT + Parameters.SPAWN_CHANCE_UMBRELLA + Parameters.SPAWN_CHANCE_NET:
		add_weapon(_NET_SCENE) # spawn net
	
	# random movement speed
	var random_multiplier: float = randf_range(Parameters.SPEED_MULTIPLIER_MINIMUM, Parameters.SPEED_MULTIPLIER_MAXIMUM)
	human_moving_speed = random_multiplier
	human_sprite.speed_scale = random_multiplier


func _physics_process(delta) -> void: 
	
	# move human
	position.x += pow(-1, int(human_sprite.flip_h)) * delta * GENERAL_SPEED_MULTIPLIER * human_moving_speed
	
	# flip human and items
	human_sprite.flip_h = moving_direction
	left_hand_point.position.x = 40 - int(human_sprite.flip_h) * 100
	right_hand_point.position.x = 40 - int(human_sprite.flip_h) * 100
	head_point.position.x = 15 - int(human_sprite.flip_h) * 30
	if left_hand_point.get_children().size() > 0:
		left_hand_point.get_child(0).scale.x = 0.2 * pow(-1, int(human_sprite.flip_h))
	
	# human death
	if current_life_points <= 0:
		human_sprite.play("death")
		SoundManager.play_sound.emit("death")
		Globals.score += 1
		await get_tree().create_timer(0.5).timeout
		queue_free()


func add_pick_up(pick_up_type: Enum.PoopType):
	var new_pick_up = _PICK_UP_SCENE.instantiate()
	new_pick_up.set_resource(Globals.poop_resources[pick_up_type])
	right_hand_point.add_child(new_pick_up)


func add_weapon(armor_scene: PackedScene):
	var new_armor = armor_scene.instantiate()
	left_hand_point.add_child(new_armor)


func add_head_armor(armor_scene: PackedScene):
	var new_armor = armor_scene.instantiate()
	head_point.add_child(new_armor)


func take_damage(damage: int):
	current_life_points -= damage


func _on_timer_change_direction_timeout() -> void:
	moving_direction = randi_range(0, 1)
