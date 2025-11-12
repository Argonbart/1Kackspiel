extends Node2D


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		event = event as InputEventKey
		if event.keycode == KEY_SPACE:
			if event.is_released():
				button_pressed()


func button_pressed() -> void:
	GameStateManager.restart()
	call_deferred("queue_free") 
