extends CanvasLayer


# constants
const _POOP_CONTAINER = preload("res://scenes/poop_container.tscn")
const _POOP_SCENE = preload("res://scenes/poop.tscn")
const _FIRE_POOP_SCENE = preload("res://scenes/fire_poop.tscn")
const _ICEBOMB_SCENE = preload("res://scenes/icebomb.tscn")

@export var containers: HBoxContainer
@export var bird: CharacterBody2D

var tween: Tween


func _ready():
	
	Globals.connect("item_collected", add_ammo)
	Globals.connect("pooped", use_ammo)
	
	init_poop_containers()


func init_poop_containers():
	for i in range(2):
		create_new_poop_container(Globals.PICK_UP.BERRIES)
	Globals.ammo_is_empty = false
	Globals.next_ammo_type = Globals.PICK_UP.BERRIES
	Globals.next_ammo_color = Globals.pick_up_list[Globals.PICK_UP.BERRIES].color


func add_ammo(ammo_type: Globals.PICK_UP):
	for i in range(Globals.pick_up_list[ammo_type].amount):
		add_one_ammo(ammo_type)
		await get_tree().create_timer(0.3).timeout


func add_one_ammo(ammo_type: Globals.PICK_UP):
	var old_container_position = containers.position
	tween = create_tween()
	tween.tween_property(containers, "position", old_container_position + Vector2(50.0, 0.0), 0.2)
	await get_tree().create_timer(0.2).timeout
	create_new_poop_container(ammo_type)
	containers.position = old_container_position
	
	# update global ammo variables
	call_deferred("update_global_ammo_variables")


func use_ammo():
	
	# check if ammo available
	if Globals.ammo_is_empty:
		return
	
	# remove last poop container
	containers.get_child(containers.get_children().size() - 1).queue_free()
	
	# active poop effect
	activate_poop_effect()
	
	# update global ammo variables
	call_deferred("update_global_ammo_variables")


func update_global_ammo_variables():
	
	Globals.ammo_is_empty = false
	if containers.get_children().size() < 1:
		Globals.ammo_is_empty = true
		return
	
	var next_ammo: PoopContainer = containers.get_child(containers.get_children().size() - 1)
	Globals.next_ammo_type = next_ammo.get_type()
	Globals.next_ammo_color = next_ammo.get_color()


func create_new_poop_container(ammo_type: Globals.PICK_UP):
	var picked_up_ammo = Globals.pick_up_list[ammo_type] as PickUp
	var ammo_color = picked_up_ammo.color
	var new_poop_container: PoopContainer = _POOP_CONTAINER.instantiate()
	new_poop_container.set_type(ammo_type)
	new_poop_container.set_color(ammo_color)
	containers.add_child(new_poop_container)
	containers.move_child(new_poop_container, 0)


func activate_poop_effect():
	match Globals.next_ammo_type:
		Globals.PICK_UP.BERRIES:	 # nothing additional happens
			pass
		Globals.PICK_UP.HOTDOG:		 # fire rain
			for i in range(2, 16):
				var new_poop = _FIRE_POOP_SCENE.instantiate()
				#new_poop.set_color(Globals.next_ammo_color)
				new_poop.global_position = bird.get_child(0).global_position
				get_parent().add_child(new_poop)
				await get_tree().create_timer(0.1).timeout
		Globals.PICK_UP.ICECREAM:
			var new_poop = _POOP_SCENE.instantiate()
			new_poop.set_color(Globals.next_ammo_color)
			new_poop.global_position = bird.get_child(0).global_position
			get_parent().add_child(new_poop)
			var new_ice_bomb: Area2D = _ICEBOMB_SCENE.instantiate()
			#new_ice_bomb.global_position = new_poop.global_position
			new_poop.add_child(new_ice_bomb)
			await get_tree().create_timer(1.0).timeout
			if new_ice_bomb:
				new_ice_bomb.explode()
