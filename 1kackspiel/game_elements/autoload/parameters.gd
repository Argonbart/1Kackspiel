extends Node


var RESET_SCORES: bool = false

# globals
var LONG_PRESS_TIME: float = 0.5
var DOUBLE_CLICK_TIME: float = 0.3
var GAME_LENGTH: int = 120

# bird
var FLYING_SPEED: float = 300.0

# spawner
var SPAWN_TIMER_MINIMUM: float = 2.0
var SPAWN_TIMER_MAXIMUM: float = 4.0

# human
var SPAWN_CHANCE_BERRY: float = 0.2
var SPAWN_CHANCE_FIRE: float = 0.3
var SPAWN_CHANCE_ICE: float = 0.3
var SPAWN_CHANCE_RIGHT_NOTHING: float = 0.2
var SPAWN_CHANCE_HAT: float = 0.2
var SPAWN_CHANCE_UMBRELLA: float = 0.2
var SPAWN_CHANCE_NET: float = 0.1
var SPAWN_CHANCE_LEFT_NOTHING: float = 0.5
var SPEED_MULTIPLIER_MINIMUM: float = 0.8
var SPEED_MULTIPLIER_MAXIMUM: float = 1.2
var BASIC_LIFE_POINTS: int = 1

# poop
var FALLING_FORCE_X: float = 2.0
var FALLING_FORCE_Y: float = 2.0
var FALLING_FORCE_DROPOFF_X: float = 1.0

# effects
var FIRE_POOP_AMOUNT: int = 10
var CHESTNUT_PROJECTILE_SPEED: float = 1000.0
var CHESTNUT_MAX_TARGETS_HIT: int = 3
var ICE_EXPLOSION_RADIUS: float = 400.0
var ICE_EXPANDING_SPEED_MULTIPLIER: float = 0.2

# ui
var MAX_POOP_CONTAINERS: int = 10

# data
var data_path: String = "res://resources/csv/parameters.csv"
var data: Array = []


func _ready() -> void:
	var file = FileAccess.open(data_path, FileAccess.READ)
	var content = file.get_csv_line(",")
	while !file.eof_reached():
		data.append(float(content[2]))
		content = file.get_csv_line(",")
	data.append(float(content[2]))
	data.remove_at(0)
	set_all_parameters()


func set_all_parameters():
	LONG_PRESS_TIME = data[0]
	DOUBLE_CLICK_TIME = data[1]
	GAME_LENGTH = data[2]
	FLYING_SPEED = data[3]
	SPAWN_TIMER_MINIMUM = data[4]
	SPAWN_TIMER_MAXIMUM = data[5]
	SPAWN_CHANCE_BERRY = data[6]
	SPAWN_CHANCE_FIRE = data[7]
	SPAWN_CHANCE_ICE = data[8]
	SPAWN_CHANCE_RIGHT_NOTHING = data[9]
	SPAWN_CHANCE_HAT = data[10]
	SPAWN_CHANCE_UMBRELLA = data[11]
	SPAWN_CHANCE_NET = data[12]
	SPAWN_CHANCE_LEFT_NOTHING = data[13]
	SPEED_MULTIPLIER_MINIMUM = data[14]
	SPEED_MULTIPLIER_MAXIMUM = data[15]
	BASIC_LIFE_POINTS = data[16]
	FALLING_FORCE_X = data[17]
	FALLING_FORCE_Y = data[18]
	FALLING_FORCE_DROPOFF_X = data[19]
	FIRE_POOP_AMOUNT = data[20]
	CHESTNUT_PROJECTILE_SPEED = data[21]
	CHESTNUT_MAX_TARGETS_HIT = data[22]
	ICE_EXPLOSION_RADIUS = data[23]
	ICE_EXPANDING_SPEED_MULTIPLIER = data[24]
	MAX_POOP_CONTAINERS = data[25]
