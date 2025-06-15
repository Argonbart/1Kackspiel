class_name KastaniePoop
extends Node2D


# exports
@export_category("falling force")
@export var falling_force_x: float = -20.0
@export var falling_force_y: float = 4.0
@export var falling_force_dropoff_x: float = 0.3
# -
@export var poop_body: StaticBody2D
@export var poop_area: Area2D
@export var poop_color_sprite: Sprite2D

@export var projectiles: Node2D

# variables
var hit_ground: bool = false
var timer: Timer

# poop falling variables
@onready var fall_direction: bool = Globals.invert_direction


func _ready():
	set_color(Globals.pick_up_list[Globals.PICK_UP.CHESTNUT].color)


# movement
func _physics_process(delta):
	if kill_limit <= 0:
		queue_free()
	
	if !hit_ground:
		position += Vector2(falling_force_x * pow(-1, fall_direction), falling_force_y)
		falling_force_x -= falling_force_dropoff_x
		if falling_force_x < 0.0:
			falling_force_x = 0.0
	poop_body.move_and_collide(Vector2(0.0, 1.0) * delta)


func _on_poop_area_area_entered(area: Area2D):
	
	if area.get_groups().has("chestnut"):
		return
	
	hit_ground = true
	poop_area.set_deferred("monitoring", false)
	shoot_projectiles()
	await get_tree().create_timer(10.0).timeout
	queue_free()


func set_color(new_color: Color):
	poop_color_sprite.self_modulate = new_color


func shoot_projectiles():
	var directions = [
		Vector2(0.0, -1.0),
		Vector2(1.0, 0.0),
		Vector2(0.0, 1.0),
		Vector2(-1.0, 0.0),
		Vector2(1.0, -1.0),
		Vector2(1.0, 1.0),
		Vector2(-1.0, 1.0),
		Vector2(-1.0, -1.0),
	]
	var i = 0
	for projectile in projectiles.get_children():
		var direction = directions[i]
		projectile.direction = direction
		i += 1


var kill_limit = 3
func _on_area_2d_area_entered(area):
	if area.get_groups().has("umbrella") or area.get_groups().has("human"):
		area.get_parent().queue_free()
		kill_limit -= 1
