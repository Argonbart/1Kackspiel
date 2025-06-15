extends Control

@export var scoreText: Label
@export var newGameButton: TextureButton

func _ready():
	newGameButton.grab_focus()
	var world = get_tree().current_scene
	world.get_node("UI").hide()
	scoreText.text = str(Globals.score)
	Globals.invert_direction = false;
	

func _on_texture_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	queue_free() 
