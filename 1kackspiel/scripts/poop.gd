class_name Poop
extends Node2D


# exports
@export_category("falling force")
@export var falling_force_x: float = -20.0
@export var falling_force_y: float = 4.0
@export var falling_force_dropoff_x: float = 0.3
# -
@export var poop_body: StaticBody2D
@export var poop_area: Area2D

# variables
var hit_ground: bool = false

# poop falling variables
@onready var fall_direction: bool = Globals.invert_direction

# movement
func _physics_process(delta):
	if !hit_ground:
		position += Vector2(falling_force_x * pow(-1, fall_direction), falling_force_y)
		falling_force_x -= falling_force_dropoff_x
		if falling_force_x < 0.0:
			falling_force_x = 0.0
	poop_body.move_and_collide(Vector2(0.0, 1.0) * delta)


func _on_poop_area_area_entered(_area: Area2D):
	hit_ground = true
	poop_area.set_deferred("monitoring", false)
