extends Area2D


@export var umbrella_sprite: Sprite2D
@export var umbrella_usual: Texture
@export var umbrella_special: Texture


func _ready() -> void:
	if randi_range(1,100) == 100:
		umbrella_sprite.texture = umbrella_special
	else:
		umbrella_sprite.texture = umbrella_usual


func take_damage(_damage):
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.get_groups().has("poop"):
		SoundManager.play_sound.emit("umbrella_destroyed")
