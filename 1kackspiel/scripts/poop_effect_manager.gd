class_name PoopEffectManager
extends Node

@export_category("Balancing Poop")
@export var _FIRE_POOP_AMOUNT: int = 10
@export_category("Nodes")
@export var bird: Bird
@export_category("Scenes")
@export var _POOP_SCENE: PackedScene
@export var _ICE_EXPLOSION: PackedScene


func _ready() -> void:
	AmmunitionManager.connect("use_ammo", activate_poop_effect)


func activate_poop_effect():
	
	# create new poop
	var new_poop = _POOP_SCENE.instantiate()
	var _poop_resource: PoopResource = Globals.poop_resources[AmmunitionManager.next_ammo_type]
	if _poop_resource.poop_sprite_frames:
		new_poop.poop_sprite.sprite_frames = _poop_resource.poop_sprite_frames
		new_poop.poop_sprite.scale = _poop_resource.poop_sprite_scaling
	new_poop.set_color(Globals.poop_resources[AmmunitionManager.next_ammo_type].poop_color)
	
	match AmmunitionManager.next_ammo_type:
		Enum.PoopType.BERRIES: # throw single normal poop
			new_poop.global_position = bird.bird_sprite.global_position + Vector2(0.0, 100.0)
			get_parent().get_parent().find_child("Poops").add_child(new_poop)
		Enum.PoopType.CHESTNUT:
			pass
		Enum.PoopType.HOTDOG: # throw multiple fire poops
			for i in range(_FIRE_POOP_AMOUNT):
				var fire_poop = new_poop.duplicate()
				fire_poop.global_position = bird.bird_sprite.global_position + Vector2(0.0, 100.0)
				get_parent().get_parent().find_child("Poops").add_child(fire_poop)
				await get_tree().create_timer(0.1).timeout
		Enum.PoopType.ICECREAM: # spawn big ice bomb
			new_poop.global_position = bird.bird_sprite.global_position + Vector2(0.0, 100.0)
			get_parent().get_parent().find_child("Poops").add_child(new_poop)
			var ice_explosion = _ICE_EXPLOSION.instantiate()
			new_poop.add_child(ice_explosion)

		#Enum.PoopType.ICECREAM:
			#pass
			##var new_poop = _POOP_SCENE.instantiate()
			##new_poop.set_color(Globals.next_ammo_color)
			##new_poop.global_position = bird.get_child(0).global_position
			##get_parent().add_child(new_poop)
			##var new_ice_bomb = _ICEBOMB_SCENE.instantiate()
			##new_ice_bomb.global_position = new_poop.global_position
			##new_poop.add_child(new_ice_bomb)
			##await get_tree().create_timer(1.0).timeout
			##if new_ice_bomb:
				##new_ice_bomb.explode()
		#Enum.PoopType.CHESTNUT:
			##var new_poop = _CHESTNUT_POOP_SCENE.instantiate()
			##new_poop.set_color(AmmunitionManager.next_ammo_color)
			##new_poop.global_position = bird.get_child(0).global_position
			##get_parent().add_child(new_poop)
			#pass
