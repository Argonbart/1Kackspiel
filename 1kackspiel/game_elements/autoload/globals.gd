extends Node


# signals
signal item_collected(poop_type: Enum.PoopType)
signal hide_ui()

# poop resource paths
const POOP_RESOURCE_BERRY = preload("res://resources/poop_resources/berry.tres")
const POOP_RESOURCE_CHESTNUT = preload("res://resources/poop_resources/chestnut.tres")
const POOP_RESOURCE_FIRE = preload("res://resources/poop_resources/fire.tres")
const POOP_RESOURCE_ICE = preload("res://resources/poop_resources/ice.tres")

# poop resources
var poop_resources = {
	Enum.PoopType.BERRY : POOP_RESOURCE_BERRY,
	Enum.PoopType.CHESTNUT : POOP_RESOURCE_CHESTNUT,
	Enum.PoopType.FIRE : POOP_RESOURCE_FIRE,
	Enum.PoopType.ICE : POOP_RESOURCE_ICE,
}

# variables
var invert_direction: bool = false # 0 = nach rechts ; 1 = nach links
var countdown: int
var score: int


func _ready():
	item_collected.get_name()
	hide_ui.get_name()
