class_name Poop
extends Node2D


# nodes
@export var poop_color_sprite: Sprite2D
@export var poop_sprite: AnimatedSprite2D
@export var poop_area: Area2D
@export var poop_particles: CPUParticles2D

# variables
var hit_ground: bool = false


# movement
func _process(_delta):
	
	if hit_ground:
		return
	
	position += Vector2(Parameters.FALLING_FORCE_X * pow(-1, Globals.invert_direction) * (-1), Parameters.FALLING_FORCE_Y)
	if Parameters.FALLING_FORCE_X > 0.0:
		Parameters.FALLING_FORCE_X -= Parameters.FALLING_FORCE_DROPOFF_X
		if Parameters.FALLING_FORCE_X <= 0.0:
			Parameters.FALLING_FORCE_X = 0.0


func set_color(new_color: Color):
	poop_color_sprite.self_modulate = new_color


func explode_on_impact(area: Area2D):
	if area.get_groups().has("ground"):
		explode_on_ground()
	else:
		explode_on_object()


func explode_on_ground():
	poop_particles.spread = 100.0
	explode()


func explode_on_object():
	poop_particles.spread = 180.0
	explode()


func explode():
	
	# poop animation
	poop_particles.emitting = true
	
	# disable poop
	hit_ground = true
	poop_area.set_deferred("monitoring", false)
	poop_sprite.visible = false
	poop_color_sprite.visible = false
	
	# special effects
	var no_effects: bool = true
	for child in get_children():
		if child.get_groups().has("ice"):
			var ice_explosion = child as IceExplosion
			if !ice_explosion.has_connections("explosion_finished"):
				ice_explosion.connect("explosion_finished", delete)
			ice_explosion.explode()
			no_effects = false
		if child.get_groups().has("chestnut"):
			var chestnut_explosion = child as ChestnutExplosion
			if !chestnut_explosion.has_connections("explosion_finished"):
				chestnut_explosion.connect("explosion_finished", delete)
			chestnut_explosion.explode()
			no_effects = false
	
	# remove
	if no_effects:
		await get_tree().create_timer(poop_particles.lifetime / poop_particles.speed_scale).timeout
		delete()


func delete():
	queue_free()


func _on_poop_area_area_entered(area: Area2D):
	
	if area.get_groups().has("can_get_damage"):
		area.take_damage(1)
	
	if area.get_groups().has("can_get_hit"):
		explode_on_impact(area)
