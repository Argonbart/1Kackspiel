class_name PoopEffectManager
extends Node

@export_category("Balancing Poop")
@export var _FIRE_POOP_AMOUNT: int = 10
@export_category("Nodes")
@export var bird: Bird
@export_category("Scenes")
@export var _POOP_SCENE: PackedScene
@export var _ICE_EXPLOSION: PackedScene
@export var _CHESTNUT_EXPLOSION: PackedScene
@export var _FIRE_EFFECT: PackedScene


func _ready() -> void:
	AmmunitionManager.connect("use_ammo", activate_poop_effect)


func activate_poop_effect():
	
	# create new poop
	var new_poop = _POOP_SCENE.instantiate()
	var _poop_resource: PoopResource = Globals.poop_resources[AmmunitionManager.next_ammo_type]
	new_poop.poop_sprite.sprite_frames = _poop_resource.poop_sprite_frames
	new_poop.poop_sprite.scale = _poop_resource.poop_sprite_scaling
	new_poop.set_color(Globals.poop_resources[AmmunitionManager.next_ammo_type].poop_color)
	
	match AmmunitionManager.next_ammo_type:
		Enum.PoopType.BERRY: # throw single normal poop
			AmmunitionManager.next_ammo.emit()
			new_poop.global_position = bird.bird_sprite.global_position + Vector2(0.0, 100.0)
			get_parent().get_parent().find_child("Poops").add_child(new_poop)
		Enum.PoopType.CHESTNUT: # spawn chestnut bomb
			AmmunitionManager.next_ammo.emit()
			new_poop.global_position = bird.bird_sprite.global_position + Vector2(0.0, 100.0)
			get_parent().get_parent().find_child("Poops").add_child(new_poop)
			var chestnut_explosion = _CHESTNUT_EXPLOSION.instantiate()
			new_poop.add_child(chestnut_explosion)
		Enum.PoopType.FIRE: # throw multiple fire poops
			AmmunitionManager.next_ammo.emit()
			for i in range(_FIRE_POOP_AMOUNT):
				var fire_poop = new_poop.duplicate()
				fire_poop.global_position = bird.bird_sprite.global_position + Vector2(0.0, 100.0)
				get_parent().get_parent().find_child("Poops").add_child(fire_poop)
				var fire_effect = _FIRE_EFFECT.instantiate()
				fire_poop.add_child(fire_effect)
				await get_tree().create_timer(0.1).timeout
		Enum.PoopType.ICE: # spawn big ice bomb
			AmmunitionManager.next_ammo.emit()
			new_poop.global_position = bird.bird_sprite.global_position + Vector2(0.0, 100.0)
			get_parent().get_parent().find_child("Poops").add_child(new_poop)
			var ice_explosion = _ICE_EXPLOSION.instantiate()
			new_poop.add_child(ice_explosion)
