extends Node


# signals
signal item_collected(pick_up_type: Globals.PICK_UP)
signal pooped()
signal next_ammo_color(color: Color)


# movement variables
var invert_direction: bool = false # 0 = nach rechts ; 1 = nach links


# dict
enum PICK_UP {
	BERRIES,
	HOTDOG,
	ICECREME
}


# pick up dict
var pick_up_list = {
	PICK_UP.BERRIES : "res://resources/berries.tres",
}


func _ready():
	item_collected.get_name()
	pooped.get_name()
	next_ammo_color.get_name()


## Collision Layers:
# 1 - Ground
# 2 - Bird
# 3 - Poop
# 4 - Enemy
# 5 - Umbrella, Net
# 6 - Pick Ups
