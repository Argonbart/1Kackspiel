extends Area2D


var enemies_nearby: Array[Human]


func explode():
	get_child(2).visible = true
	await get_tree().create_timer(0.2).timeout
	for enemy in enemies_nearby:
		enemy.life_points -=1
	queue_free()


func _on_area_entered(area: Area2D):
	if area.get_groups().has("human"):
		print(area.get_parent())
		enemies_nearby.append(area.get_parent())


func _on_area_exited(area):
	if area.get_groups().has("human"):
		enemies_nearby.erase(area.get_parent())
