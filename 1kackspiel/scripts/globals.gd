extends Node


# signals
signal set_container_color(container_idx: int, new_color: Color)
signal item_collected(pick_up_type: Globals.PICK_UP)


# movement variables
var invert_direction: bool = false # 0 = nach rechts ; 1 = nach links


# dict
enum PICK_UP {
	NORMAL,
	FIRE,
	NEW_TYPE
}


# pick up dict
var pick_up_list = {
	PICK_UP.NORMAL : "res://resources/normal.tres",
	PICK_UP.FIRE : "res://resources/fire.tres",
	PICK_UP.NEW_TYPE : "res://resources/new_pickup.tres"
}
