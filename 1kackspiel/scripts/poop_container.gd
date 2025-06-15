class_name PoopContainer
extends Container


@export var colored_container: TextureRect


func get_color():
	return colored_container.self_modulate


func set_color(new_color: Color):
	colored_container.self_modulate = new_color
