@tool
extends Node


@export_category("Poop Type")
@export var resource_name: String
@export var poop_type: Enum.PoopType
@export_category("Poop Attributes")
@export var poop_color: Color
@export var poop_amount: int
@export_category("Poop Visuals")
@export var poop_sprite_frames: SpriteFrames
@export var poop_sprite_scaling: Vector2
@export_category("PickUp Visuals")
@export var pick_up_icon: CompressedTexture2D
@export var pick_up_icon_background: CompressedTexture2D
@export var pick_up_icon_scaling: Vector2
@export_tool_button("Create Poop", "Callable") var create_button = create_pick_up_resource


func create_pick_up_resource():
	var new_poop: PoopResource = PoopResource.new()
	new_poop.poop_type = poop_type
	new_poop.poop_color = poop_color
	new_poop.poop_amount = poop_amount
	new_poop.poop_sprite_frames = poop_sprite_frames
	new_poop.poop_sprite_scaling = poop_sprite_scaling
	new_poop.pick_up_icon = pick_up_icon
	new_poop.pick_up_icon_background = pick_up_icon_background
	new_poop.pick_up_icon_scaling = pick_up_icon_scaling
	ResourceSaver.save(new_poop, str("res://resources/", resource_name, ".tres"))
