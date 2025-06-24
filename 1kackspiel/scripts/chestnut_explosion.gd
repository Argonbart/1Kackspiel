class_name ChestnutExplosion
extends Node2D


signal explosion_finished()

@export var projectiles: Node2D
@export var CHESTNUT_PROJECTILE_SCENE: PackedScene


func explode():
	shoot_projectiles()
	await get_tree().create_timer(2.0).timeout
	explosion_finished.emit()


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
	for i in range(8):
		var projectile: ChestnutProjectile = CHESTNUT_PROJECTILE_SCENE.instantiate()
		projectile.direction = directions[i]
		projectile.connect("projectile_hit_target", hit_target)
		projectiles.call_deferred("add_child", projectile)


func hit_target(area: Area2D):
	if area.get_groups().has("can_get_damage"):
		var damageable_object = area
		damageable_object.take_damage(1)
