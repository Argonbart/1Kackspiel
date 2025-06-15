extends CanvasLayer


# constants
const _POOP_CONTAINER = preload("res://scenes/poop_container.tscn")

@export var containers: HBoxContainer


func _ready():
	
	Globals.connect("item_collected", item_collected)
	Globals.connect("pooped", ammo_used)
	
	init_poop_containers()


func init_poop_containers():
	for i in range(5):
		create_new_poop_container()


func item_collected(item_type: Globals.PICK_UP):
	var picked_up_ammo = load(Globals.pick_up_list[item_type]) as PickUp
	var ammo_color = picked_up_ammo.color
	match item_type:
		Globals.PICK_UP.BERRIES:
			add_ammo(ammo_color, 1)


func add_ammo(ammo_color: Color, ammo_amount: int):
	for i in range(ammo_amount):
		add_one_ammo(ammo_color)


func add_one_ammo(ammo_color: Color):
	var old_container_position = containers.position
	var tween = create_tween()
	tween.tween_property(containers, "position", old_container_position + Vector2(50.0, 0.0), 0.2)
	await get_tree().create_timer(0.2).timeout
	create_new_poop_container(ammo_color)
	containers.position = old_container_position


func get_next_ammo_color():
	if (!containers.get_children().is_empty()):
		return containers.get_child(containers.get_children().size() - 1).get_color()
	else:
		return Color.BLACK


func ammo_used():
	if (!containers.get_children().is_empty()):
		containers.get_child(containers.get_children().size() - 1).queue_free()
		await get_tree().process_frame
		Globals.next_ammo_color.emit(get_next_ammo_color())


func create_new_poop_container(new_color: Color = Color(0.545, 0.18, 0.0, 0.392)):
	var new_poop_container: PoopContainer = _POOP_CONTAINER.instantiate()
	new_poop_container.set_color(new_color)
	containers.add_child(new_poop_container)
	containers.move_child(new_poop_container, 0)
