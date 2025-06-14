extends Area2D




func _on_area_entered(area: Area2D) -> void:
	print("Regenschirm berührt", area.name)
	if area.name == "PoopArea":
		print("delete Poop")
		#area.get_parent().set("should_die", true)
	
