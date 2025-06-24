class_name ChestnutProjectile
extends Sprite2D


signal projectile_hit_target(area)

@export var MAX_TARGETS_HIT: int = 3

var direction: Vector2 = Vector2(0.0, 0.0)
var targets_hit: int = 0


func _process(delta):
	position += direction * delta * 1000.0


func _on_chestnut_projectile_area_area_entered(area):
	projectile_hit_target.emit(area)
	targets_hit += 1
	if targets_hit >= MAX_TARGETS_HIT:
		queue_free()
