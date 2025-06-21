extends Control

@export var game_over_sprite : Sprite2D
@export var resetGameButton: TextureButton

func _ready():
	resetGameButton.grab_focus()
	var screen_size = get_viewport_rect().size
	game_over_sprite.position.x = screen_size.x / 2
	var world = get_tree().current_scene
	world.get_node("UI").hide()
	Globals.invert_direction = false;


func _on_texture_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	queue_free() 


# Emit signal on button input
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			_on_texture_button_pressed()
