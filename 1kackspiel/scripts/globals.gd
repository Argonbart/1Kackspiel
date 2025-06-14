extends Node


# signals
signal set_container_color(container_idx: int, new_color: Color)
signal item_collected(pick_up_type: Globals.PICK_UP)


# movement variables
var invert_direction: bool = false # 0 = nach rechts ; 1 = nach links


# dict
enum PICK_UP {
	BERRIES,
}


# pick up dict
var pick_up_list = {
	PICK_UP.BERRIES : "res://resources/berries.tres",
}


func _ready():
	set_container_color.get_name()
	item_collected.get_name()
