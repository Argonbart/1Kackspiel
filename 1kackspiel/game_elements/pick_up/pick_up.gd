class_name PickUp
extends Node


@export var poop_resource: PoopResource
@export var pick_up_background_color: Color 
@export var pick_up_background_sprite: Sprite2D
@export var pick_up_sprite: Sprite2D


func set_resource(_poop_resource: PoopResource):
	self.poop_resource = _poop_resource


func _ready() -> void:
	pick_up_background_sprite.self_modulate = pick_up_background_color
	pick_up_background_sprite.texture = poop_resource.pick_up_icon_background
	pick_up_background_sprite.scale = poop_resource.pick_up_icon_scaling
	pick_up_sprite.texture = poop_resource.pick_up_icon
	pick_up_sprite.scale = poop_resource.pick_up_icon_scaling
