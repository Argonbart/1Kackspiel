extends CanvasLayer

# exports
@export var _MAX_POOP_CONTAINERS: int = 10

# nodes
@export var containers: HBoxContainer
@export var one_second_timer: Timer 
@export var countdown_label: Label 
@export var score_label: Label 

# scenes
@export var _POOP_CONTAINER: PackedScene

# variables
var poop_to_add_queue: Array[Enum.PoopType] = []
var loading_poop: bool = false


func _ready():
	init_poop_containers()
	start_game_timer()
	Globals.connect("item_collected", add_ammo)
	Globals.connect("hide_ui", hide)
	AmmunitionManager.connect("next_ammo", move_container)


func _process(_delta) -> void:
	
	score_label.text = "Score: " + str(Globals.score)
	
	if Globals.countdown == 0:
		GameStateManager.game_won()


func init_poop_containers():
	for i in range(2):
		create_new_poop_container(Enum.PoopType.BERRY)
	AmmunitionManager.ammo_is_empty = false
	AmmunitionManager.next_ammo_type = Enum.PoopType.BERRY


func start_game_timer():
	Globals.countdown = 120
	Globals.score = 0
	countdown_label.text = "%02d:%02d" % [Globals.countdown / 60.0, Globals.countdown % 60]
	one_second_timer.start()


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


func _on_one_second_timer_timeout() -> void:
	Globals.countdown -= 1
	countdown_label.text = "%02d:%02d" % [Globals.countdown / 60.0, Globals.countdown % 60]
