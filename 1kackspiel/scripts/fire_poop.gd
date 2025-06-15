class_name FirePoop
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

# variables
var hit_ground: bool = false
var on_ground: bool = false
var timer: Timer

# poop falling variables
@onready var fall_direction: bool = Globals.invert_direction

# movement
func _physics_process(delta):
	if !on_ground:
		position += Vector2(falling_force_x * pow(-1, fall_direction), falling_force_y)
		falling_force_x -= falling_force_dropoff_x
		if falling_force_x < 0.0:
			falling_force_x = 0.0
	poop_body.move_and_collide(Vector2(0.0, 1.0) * delta)


func _on_poop_area_area_entered(area: Area2D):
	if area.get_groups().has("umbrella"):
		area.queue_free()
	if area.get_groups().has("ground"):
		#hit_ground = true
		on_ground = true
		#poop_area.set_deferred("monitoring", false)
		await get_tree().create_timer(5.0).timeout
		queue_free()


func set_color(new_color: Color):
	poop_color_sprite.self_modulate = new_color
