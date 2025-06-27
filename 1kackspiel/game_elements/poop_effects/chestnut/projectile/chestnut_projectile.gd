class_name ChestnutProjectile
extends Sprite2D


@export var MAX_TARGETS_HIT: int = 3

var direction: Vector2 = Vector2(0.0, 0.0)
var targets_hit: int = 0


func _process(delta):
	position += direction * delta * 1000.0


func _on_chestnut_projectile_area_area_entered(area):
	if area.get_groups().has("can_get_damage"):
		var damageable_object = area
		damageable_object.take_damage(1)
		targets_hit += 1
		if targets_hit >= MAX_TARGETS_HIT:
			queue_free()
