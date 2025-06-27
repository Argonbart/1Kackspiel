class_name ChestnutExplosion
extends Node2D


signal explosion_finished()

@export var projectiles: Node2D
@export var CHESTNUT_PROJECTILE_SCENE: PackedScene

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


func explode():
	shoot_projectiles()
	await get_tree().create_timer(2.0).timeout
	explosion_finished.emit()


func shoot_projectiles():
	for i in range(8):
		call_deferred("spawn_projectile", i)


func spawn_projectile(projectile_index: int):
	var projectile: ChestnutProjectile = CHESTNUT_PROJECTILE_SCENE.instantiate()
	projectile.direction = directions[projectile_index]
	projectiles.add_child(projectile)
