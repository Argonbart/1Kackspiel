extends Sprite2D


var direction: Vector2 = Vector2(0.0, 0.0)


func _process(delta):
	position += direction * delta * 1000.0
