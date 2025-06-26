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


func _on_pick_up_area_area_entered(area: Area2D):
	if area.get_groups().has("bird"):
		SoundManager.play_sound.emit("pickup")
		Globals.item_collected.emit(poop_resource.poop_type)
		queue_free()
