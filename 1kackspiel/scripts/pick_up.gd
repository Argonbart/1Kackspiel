extends Node


@export var pick_up_resource: PickUp
@onready var pick_up_sprite: Sprite2D = $Sprite


func _ready():
	pick_up_sprite.texture = pick_up_resource.icon
	pick_up_sprite.scale = pick_up_resource.icon_scaling
	pick_up_sprite.self_modulate = pick_up_resource.color


func _on_pick_up_area_area_entered(area: Area2D):
	if area.get_groups().has("bird"):
		Globals.item_collected.emit(pick_up_resource.type)
