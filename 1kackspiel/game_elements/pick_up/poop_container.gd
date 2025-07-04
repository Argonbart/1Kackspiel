class_name PoopContainer
extends Container


@export var colored_container: TextureRect
var poop_type: Enum.PoopType


func get_color():
	return colored_container.self_modulate


func get_type():
	return poop_type


func set_color(new_color: Color):
	colored_container.self_modulate = new_color


func set_type(new_type: Enum.PoopType):
	poop_type = new_type
