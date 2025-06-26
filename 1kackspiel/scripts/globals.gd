extends Node


# signals
signal item_collected(poop_type: Enum.PoopType)
signal hide_ui()

# poop resource paths
const POOP_RESOURCE_BERRIES = preload("res://resources/berries.tres")
const POOP_RESOURCE_CHESTNUT = preload("res://resources/chestnut.tres")
const POOP_RESOURCE_HOTDOG = preload("res://resources/hotdog.tres")
const POOP_RESOURCE_ICECREAM = preload("res://resources/icecream.tres")

# poop resources
var poop_resources = {
	Enum.PoopType.BERRIES : POOP_RESOURCE_BERRIES,
	Enum.PoopType.CHESTNUT : POOP_RESOURCE_CHESTNUT,
	Enum.PoopType.HOTDOG : POOP_RESOURCE_HOTDOG,
	Enum.PoopType.ICECREAM : POOP_RESOURCE_ICECREAM,
}

# variables
var invert_direction: bool = false # 0 = nach rechts ; 1 = nach links
var countdown: int
var score: int


func _ready():
	item_collected.get_name()
	hide_ui.get_name()


## Collision Layers:
# 1 - Ground
# 2 - Bird
# 3 - Poop
# 4 - Enemy
# 5 - Umbrella
# 6 - Pick Ups
# 7 - Net
# 8 - icebomb
