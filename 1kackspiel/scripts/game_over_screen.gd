extends Control

@export var game_over_sprite : Sprite2D
@export var resetGameButton: TextureButton

func _ready():
	game_over_sprite.position.x = get_viewport_rect().size.x / 2
	resetGameButton.grab_focus()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			button_pressed()


func button_pressed() -> void:
	GameStateManager.restart()
	call_deferred("queue_free") 
