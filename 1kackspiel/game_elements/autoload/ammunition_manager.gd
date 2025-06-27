extends Node


signal next_ammo()
signal use_ammo()


# next ammo variables
var next_ammo_type: Enum.PoopType
var ammo_is_empty: bool


func _ready() -> void:
	use_ammo.get_name()
	next_ammo.get_name()
