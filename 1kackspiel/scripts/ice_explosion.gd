extends Node2D


@export var ice_area: Area2D
@export var ice_particles: CPUParticles2D


func explode():
	var poop = get_parent()
	ice_particles.emitting = true
	poop.poop_sprite.visible = false
	poop.poop_color_sprite.visible = false
	$TriggerHitbox.monitorable = false
	$TriggerHitbox.monitoring = false
	await get_tree().create_timer($Paricles/CPUParticles2D.lifetime).timeout
	poop.queue_free()
