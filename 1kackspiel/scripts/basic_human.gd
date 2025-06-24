class_name Human
extends CharacterBody2D


# exports
const _PICK_UP_SCENE = preload("res://scenes/pick_up.tscn")
@export_category("Right Hand PickUp Items (need to add up to 1.0)")
@export_range(0.0, 1.0) var _SPAWN_CHANCE_BERRIES: float = 0.5
@export_range(0.0, 1.0) var _SPAWN_CHANCE_HOTDOG: float = 0.2
@export_range(0.0, 1.0) var _SPAWN_CHANCE_ICECREAM: float = 0.1
@export_range(0.0, 1.0) var _SPAWN_CHANCE_RIGHT_NOTHING: float = 0.1
@export_category("Left Hand Weapon Items + Hat (need to add up to 1.0)")
@export_range(0.0, 1.0) var _SPAWN_CHANCE_HEAD: float = 0.7
@export_range(0.0, 1.0) var _SPAWN_CHANCE_UMBRELLA: float = 0.4
@export_range(0.0, 1.0) var _SPAWN_CHANCE_NET: float = 0.09
@export_range(0.0, 1.0) var _SPAWN_CHANCE_LEFT_NOTHING: float = 0.1
@export_category("Speed Multiplier")
@export_range(0.0, 3.0) var _SPEED_MULTIPLIER_MINIMUM: float = 0.5
@export_range(0.0, 3.0) var _SPEED_MULTIPLIER_MAXIMUM: float = 2.0
@export_category("Stats")
@export var life_points: int = 1;
@export_category("Nodes")
@export var human_sprite: AnimatedSprite2D
@export var left_hand_point: Node2D
@export var right_hand_point: Node2D
@export var head_point: Node2D
@export_category("Scenes")
@export var head_scene: PackedScene
@export var umbrella_scene: PackedScene
@export var net_scene: PackedScene
@export_category("PickUps")
@export var pick_up_list: Array[Enum.PoopType]

# variables
var moving_direction: bool = false # 0 = nach rechts ; 1 = nach links
var human_moving_speed: float = 1.0


func _ready() -> void:
	
	# warning if right hand spawning chances not equal to 1.0
	if _SPAWN_CHANCE_BERRIES + _SPAWN_CHANCE_HOTDOG + _SPAWN_CHANCE_ICECREAM + _SPAWN_CHANCE_RIGHT_NOTHING != 1.0:
		push_warning("Human: Right hand item spawning chances do not add up to 1.0! ERROR")
	
	# random right hand item
	var random_righthand_item = randf()
	if random_righthand_item < _SPAWN_CHANCE_BERRIES:
		add_pick_up(Enum.PoopType.BERRIES) # spawn berries
	elif random_righthand_item < _SPAWN_CHANCE_BERRIES + _SPAWN_CHANCE_HOTDOG:
		add_pick_up(Enum.PoopType.HOTDOG) # spawn hotdog
	elif random_righthand_item < _SPAWN_CHANCE_BERRIES + _SPAWN_CHANCE_HOTDOG + _SPAWN_CHANCE_ICECREAM:
		add_pick_up(Enum.PoopType.ICECREAM) # spawn icecream
	
	# warning if left hand spawning chances not equal to 1.0
	if _SPAWN_CHANCE_HEAD + _SPAWN_CHANCE_UMBRELLA + _SPAWN_CHANCE_NET + _SPAWN_CHANCE_LEFT_NOTHING != 1.0:
		push_warning("Human: Right hand item spawning chances do not add up to 1.0! ERROR")
	
	# random left hand item
	var random_lefthand_item = randf()
	if random_lefthand_item < _SPAWN_CHANCE_HEAD:
		add_hat(head_scene) # spawn head
		life_points +=1;
	elif random_lefthand_item < _SPAWN_CHANCE_HEAD + _SPAWN_CHANCE_UMBRELLA:
		add_weapon(umbrella_scene) # spawn umbrella
	elif random_lefthand_item < _SPAWN_CHANCE_HEAD + _SPAWN_CHANCE_UMBRELLA + _SPAWN_CHANCE_NET:
		add_weapon(net_scene) # spawn net
		life_points +=4;
	
	# random movement speed
	var random_multiplier: float = randf_range(_SPEED_MULTIPLIER_MINIMUM, _SPEED_MULTIPLIER_MAXIMUM)
	human_moving_speed = random_multiplier
	human_sprite.speed_scale = random_multiplier


func _physics_process(_delta) -> void: 
	
	# move human
	move_and_collide(Vector2(pow(-1, int(human_sprite.flip_h)) * human_moving_speed, 0))
	
	# flip human and items
	human_sprite.flip_h = moving_direction
	left_hand_point.position.x = 40 - int(human_sprite.flip_h) * 100
	right_hand_point.position.x = 40 - int(human_sprite.flip_h) * 100
	head_point.position.x = 15 - int(human_sprite.flip_h) * 30
	if left_hand_point.get_children().size() > 0:
		left_hand_point.get_child(0).scale.x = 0.2 * pow(-1, int(human_sprite.flip_h))
	
	# human death
	if life_points <= 0:
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


func add_hat(armor_scene: PackedScene):
	var new_armor = armor_scene.instantiate()
	head_point.add_child(new_armor)


func _on_timer_change_direction_timeout() -> void:
	moving_direction = randi_range(0, 1)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PoopArea":
		var poop = area.get_parent()
		if poop.hit_ground:
			return
		if area.get_groups().has("chestnut"):
			area.get_parent().get_parent().shoot_projectiles()
			await get_tree().create_timer(10.0).timeout
		if area.get_groups().has("ice"):
			await get_tree().create_timer(1.0).timeout
			var new_poop = area.get_parent().get_parent()
			if new_poop:
				new_poop.explode()
		poop.queue_free()
		life_points -= 1
