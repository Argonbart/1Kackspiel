class_name Poop
extends Node2D


# exports
@export var poop_body: StaticBody2D
@export var poop_area: Area2D

#variables
var hit_ground: bool = false


# movement
func _physics_process(delta):
	if hit_ground:
		position.x -= 300.0 * delta * pow(-1, Globals.invert_direction)
	position.y += 5.0
	poop_body.move_and_collide(Vector2(0.0, 1.0) * delta)


func _on_poop_area_area_entered(area):
	print(area.name)
	hit_ground = true
	poop_area.set_deferred("monitoring", false)
