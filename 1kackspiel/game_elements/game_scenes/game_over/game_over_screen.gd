extends Node2D


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			button_pressed()


func button_pressed() -> void:
	GameStateManager.restart()
	call_deferred("queue_free") 
