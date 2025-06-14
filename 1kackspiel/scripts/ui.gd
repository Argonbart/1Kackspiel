extends CanvasLayer


@export var color_containers: Array[TextureRect]


func _ready():
	Globals.connect("set_container_color", update_color_container)
	Globals.connect("item_collected", item_collected)


func update_color_container(container_idx: int, new_color: Color):
	color_containers[container_idx].self_modulate = new_color


func item_collected(item_type: Globals.PICK_UP):
	match item_type:
		Globals.PICK_UP.BERRIES:
			update_color_container(0, Color.RED)
