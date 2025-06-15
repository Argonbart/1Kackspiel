extends Node


const _BERRIES = preload("res://resources/berries.tres")
const _HOTDOG = preload("res://resources/hotdog.tres")
const _ICECREAM = preload("res://resources/icecream.tres")
const _CHESTNUT = preload("res://resources/chestnut.tres")


# signals
signal item_collected(pick_up_type: Globals.PICK_UP)
signal pooped()


# movement variables
var invert_direction: bool = false # 0 = nach rechts ; 1 = nach links


# next ammo variables
var next_ammo_type: PICK_UP
var next_ammo_color: Color
var ammo_is_empty: bool


# dict
enum PICK_UP {
	BERRIES,
	HOTDOG,
	ICECREAM,
	CHESTNUT,
}


# pick up dict
var pick_up_list = {
	PICK_UP.BERRIES : _BERRIES,
	PICK_UP.HOTDOG : _HOTDOG,
	PICK_UP.ICECREAM : _ICECREAM,
	PICK_UP.CHESTNUT : _CHESTNUT,
}


func _ready():
	item_collected.get_name()
	pooped.get_name()


## Collision Layers:
# 1 - Ground
# 2 - Bird
# 3 - Poop
# 4 - Enemy
# 5 - Umbrella
# 6 - Pick Ups
# 7 - Net
# 8 - icebomb
