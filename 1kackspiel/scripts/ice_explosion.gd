class_name IceExplosion
extends Node2D


signal explosion_finished()


@export var ice_area: Area2D
@export var ice_particles: CPUParticles2D

var damageable_objects: Array = []


func explode():
	ice_particles.emitting = true
	await get_tree().create_timer(0.1).timeout
	for damageable_object in damageable_objects:
		damageable_object.take_damage(1)
	await get_tree().create_timer(ice_particles.lifetime).timeout
	explosion_finished.emit()


func _on_explosion_area_area_entered(area: Area2D):
	if area.get_groups().has("can_get_damage"):
		damageable_objects.append(area)


func _on_explosion_area_area_exited(area):
	if area.get_groups().has("can_get_damage"):
		damageable_objects.erase(area)
