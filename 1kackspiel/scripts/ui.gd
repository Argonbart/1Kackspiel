extends CanvasLayer


# exports
@export var _MAX_POOP_CONTAINERS: int = 10
@export var _POOP_CONTAINER: PackedScene
@export var containers: HBoxContainer

# variables
var poop_to_add_queue: Array[Enum.PoopType] = []
var loading_poop: bool = false


func _ready():
	init_poop_containers()
	Globals.connect("item_collected", add_ammo)
	AmmunitionManager.connect("use_ammo", move_container)


func init_poop_containers():
	for i in range(2):
		create_new_poop_container(Enum.PoopType.BERRIES)
	AmmunitionManager.ammo_is_empty = false
	AmmunitionManager.next_ammo_type = Enum.PoopType.BERRIES


func add_ammo(ammo_type: Enum.PoopType):
	for i in range(Globals.poop_resources[ammo_type].poop_amount):
		if containers.get_children().size() >= _MAX_POOP_CONTAINERS:
			return
		poop_to_add_queue.append(ammo_type)
	
	if loading_poop:
		return
	
	loading_poop = true
	while !poop_to_add_queue.is_empty():
		create_new_poop_container(poop_to_add_queue[0])
		poop_to_add_queue.remove_at(0)
		await get_tree().create_timer(0.1).timeout
	loading_poop = false
	
	if AmmunitionManager.ammo_is_empty:
		AmmunitionManager.next_ammo_type = containers.get_child(0).get_type()
		AmmunitionManager.ammo_is_empty = false


func create_new_poop_container(ammo_type: Enum.PoopType):
	var new_poop_container: PoopContainer = _POOP_CONTAINER.instantiate()
	new_poop_container.set_type(ammo_type)
	new_poop_container.set_color(Globals.poop_resources[ammo_type].poop_color)
	containers.add_child(new_poop_container)


func move_container():
	
	# ammo count = 0 - nothing to remove
	if containers.get_children().size() < 1:
		return
	
	# ammo count = 1 - will get removed
	if containers.get_children().size() < 2:
		containers.get_child(0).queue_free()
		AmmunitionManager.ammo_is_empty = true
		return
	
	# ammo count = 2+ - one will get removed, one will get set as next
	if containers.get_children().size() > 1:
		containers.get_child(0).queue_free()
		AmmunitionManager.next_ammo_type = containers.get_child(1).get_type()
		AmmunitionManager.ammo_is_empty = false
