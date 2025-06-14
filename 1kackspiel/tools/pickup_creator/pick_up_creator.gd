@tool
extends Node


@export var power_up_name: String
@export var type: Globals.PICK_UP
@export var color: Color
@export var icon: CompressedTexture2D
@export var icon_background: CompressedTexture2D
@export var icon_scaling: Vector2 = Vector2(1.0, 1.0)
@export_tool_button("Create Pick Up", "Callable") var create_button = create_pick_up_resource


func create_pick_up_resource():
	var new_pick_up: PickUp = PickUp.new()
	new_pick_up.type = type
	new_pick_up.color = color
	new_pick_up.icon = icon
	new_pick_up.icon_background = icon_background
	new_pick_up.icon_scaling = icon_scaling
	ResourceSaver.save(new_pick_up, str("res://resources/", power_up_name, ".tres"))
