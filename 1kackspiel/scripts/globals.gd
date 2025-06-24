extends Node


# signals
signal item_collected(pick_up_type: Enum.PoopType)
signal pooped()

const POOP_RESOURCE_BERRIES = preload("res://resources/berries.tres")
const POOP_RESOURCE_CHESTNUT = preload("res://resources/chestnut.tres")
const POOP_RESOURCE_HOTDOG = preload("res://resources/hotdog.tres")
const POOP_RESOURCE_ICECREAM = preload("res://resources/icecream.tres")

# movement variables
var invert_direction: bool = false # 0 = nach rechts ; 1 = nach links

# counter
var countdown: int

#score
var score: int

var poop_resources = {
	Enum.PoopType.BERRIES : POOP_RESOURCE_BERRIES,
	Enum.PoopType.CHESTNUT : POOP_RESOURCE_CHESTNUT,
	Enum.PoopType.HOTDOG : POOP_RESOURCE_HOTDOG,
	Enum.PoopType.ICECREAM : POOP_RESOURCE_ICECREAM,
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
