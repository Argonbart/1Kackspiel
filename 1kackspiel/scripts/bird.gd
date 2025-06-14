extends CharacterBody2D


# signals
signal button_pressed
signal button_released

# constants
@export var FLYING_SPEED: float = 300.0
@export var LONG_PRESS_TIME: float = 0.5		# time till press counts as long press
@export var DOUBLE_CLICK_TIME: float = 0.3		# time it waits for a second press after first short press

# other scenes
@onready var _POOP_SCENE = preload("res://scenes/poop.tscn")

# exports
@export var bird_sprite: AnimatedSprite2D
@export var camera: Camera2D

# button variables
var time_when_button_was_pressed: float = 0.0
var time_of_first_short_button_press: float = -1.0
var waiting_for_double_press: bool = false
var time_when_button_was_released: float = 0.0

# eating variables
var diving: float = false

# other variables
var currently_executing_command: bool = false


# Connect signals
func _ready():
	connect("button_pressed", button_just_pressed)
	connect("button_released", button_just_released)


# Set direction and move
func _process(delta):
	position.x += FLYING_SPEED * delta * pow(-1, Globals.invert_direction)
	position.y += diving * delta
	camera.position.y += -diving * delta
	move_and_slide()


# Emit signal on button input
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			button_pressed.emit()
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			button_released.emit()


# Button down
func button_just_pressed():
	if currently_executing_command:
		return
	time_when_button_was_pressed = Time.get_unix_time_from_system()		# safe timing of button press


# Button up
func button_just_released():
	if currently_executing_command:
		return
	time_when_button_was_released = Time.get_unix_time_from_system()
	var held_duration = time_when_button_was_released - time_when_button_was_pressed
	if held_duration >= LONG_PRESS_TIME:
		currently_executing_command = true
		eat() # Long press
		waiting_for_double_press = false
	else:
		if waiting_for_double_press and (time_when_button_was_released - time_of_first_short_button_press) <= DOUBLE_CLICK_TIME:
			currently_executing_command = true
			change_direction() # Double-click
			waiting_for_double_press = false
		else:
			# Start waiting for a second click
			waiting_for_double_press = true
			time_of_first_short_button_press = time_when_button_was_released
			# Wait to confirm it's not a double click
			await get_tree().create_timer(DOUBLE_CLICK_TIME).timeout
			if waiting_for_double_press:
				currently_executing_command = true
				poop() # Single short click
				waiting_for_double_press = false


func eat() -> void:
	dive_down()
	await get_tree().create_timer(1.0).timeout
	dive_up()
	await get_tree().create_timer(1.0).timeout
	stop_dive()
	currently_executing_command = false


func dive_down():
	diving = 400.0


func dive_up():
	diving = -400.0


func stop_dive():
	diving = 0.0


func change_direction():
	Globals.invert_direction = !Globals.invert_direction
	bird_sprite.flip_h = !bird_sprite.flip_h
	currently_executing_command = false


func poop():
	var new_poop = _POOP_SCENE.instantiate()
	new_poop.global_position = bird_sprite.global_position
	get_parent().add_child(new_poop)
	currently_executing_command = false
