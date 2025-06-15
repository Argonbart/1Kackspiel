extends CharacterBody2D


# signals
signal button_pressed
signal button_released

# constants
@export var FLYING_SPEED: float = 300.0
@export var Y_DIVE_DISTANCE: float = 300.0
@export var LONG_PRESS_TIME: float = 0.5		# time till press counts as long press
@export var DOUBLE_CLICK_TIME: float = 0.3		# time it waits for a second press after first short press
@export var LEFT_BOUNDRY: float = -5300.0
@export var RIGHT_BOUNDRY: float = 5300.0

# other scenes
@onready var _POOP_SCENE = preload("res://scenes/poop.tscn")
@onready var _FIRE_POOP_SCENE = preload("res://scenes/fire_poop.tscn")
@onready var _ICE_POOP_SCENE = preload("res://scenes/ice_poop.tscn")

# exports
@export var bird_sprite: AnimatedSprite2D
@export var camera: Camera2D

# button variables
var time_when_button_was_pressed: float = 0.0
var time_of_first_short_button_press: float = -1.0
var waiting_for_double_press: bool = false
var time_when_button_was_released: float = 0.0

# eating variables
var diving_neutral_y: float = 324.0
var diving_diff: float = 0.0

# other variables
var currently_executing_command: bool = false


# Connect signals
func _ready():
	connect("button_pressed", button_just_pressed)
	connect("button_released", button_just_released)


# Set direction and move
func _process(delta):
	position.x += FLYING_SPEED * delta * pow(-1, Globals.invert_direction)
	if position.x < LEFT_BOUNDRY or position.x > RIGHT_BOUNDRY:
		change_direction()
	position.y = diving_neutral_y + diving_diff
	camera.position.y = -diving_diff
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
	dive()
	await get_tree().create_timer(1.0).timeout
	currently_executing_command = false


func dive():
	bird_sprite.play("dive_down")
	
	# Dive down with ease-in-out
	var dive_tween1 = create_tween()
	dive_tween1.tween_property(self, "diving_diff", 300.0, 0.6)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	var dive_tween2 = create_tween()
	dive_tween2.tween_property(bird_sprite, "rotation_degrees", pow(-1, Globals.invert_direction) * 45.0, 0.3)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.5).timeout
	var dive_tween3 = create_tween()
	dive_tween3.tween_property(bird_sprite, "rotation_degrees", 0.0, 0.3)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.4).timeout
	
	# Dive down with ease-in-out
	var dive_tween4 = create_tween()
	dive_tween4.tween_property(self, "diving_diff", 0.0, 0.6)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	var dive_tween5 = create_tween()
	dive_tween5.tween_property(bird_sprite, "rotation_degrees", pow(-1, Globals.invert_direction) * -45.0, 0.1)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.5).timeout
	var dive_tween6 = create_tween()
	dive_tween6.tween_property(bird_sprite, "rotation_degrees", 0.0, 0.5)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.4).timeout
	await get_tree().create_timer(0.3).timeout
	
	bird_sprite.play("default")


func change_direction():
	Globals.invert_direction = !Globals.invert_direction
	bird_sprite.play("turning")
	bird_sprite.flip_h = !bird_sprite.flip_h
	await get_tree().create_timer(0.3).timeout
	bird_sprite.play("default")
	currently_executing_command = false


func poop():
	var random_gurr = randi_range(0, 100)
	if random_gurr < 20:
		$GurrPlayer.play()
	if Globals.ammo_is_empty:
		currently_executing_command = false
		return
	var new_poop
	var ice = false
	if Globals.next_ammo_type == Globals.PICK_UP.HOTDOG:
		new_poop = _FIRE_POOP_SCENE.instantiate()
	elif Globals.next_ammo_type == Globals.PICK_UP.ICECREAM:
		new_poop = _ICE_POOP_SCENE.instantiate()
		ice = true
	else:
		new_poop = _POOP_SCENE.instantiate()
	new_poop.set_color(Globals.next_ammo_color)
	new_poop.global_position = bird_sprite.global_position
	get_parent().add_child(new_poop)
	if ice:
		await get_tree().create_timer(1.0).timeout
		if new_poop:
			new_poop.explode()
	Globals.pooped.emit()
	currently_executing_command = false
