extends CharacterBody2D

signal button_pressed
signal button_released

@export var flying_speed: float = 300.0
@export var holding_threshold: float = 0.5
@export var double_press_threshold: float = 0.2

var direction: bool = true

# button variables
var button_is_pressed: bool = false
var button_pressed_in_seconds: float = 0.0
var short_button_just_pressed: bool = false
var button_pressed_after_short: float = 0.0

func _ready():
	# react to button
	connect("button_pressed", button_just_pressed)
	connect("button_released", button_just_released)


func _process(delta):
	
	if button_is_pressed:
		button_pressed_in_seconds += delta
	else:
		button_pressed_in_seconds = 0.0
	
	if button_pressed_after_short > double_press_threshold:
		short_button_just_pressed = false
	
	if short_button_just_pressed:
		button_pressed_after_short += delta
	else:
		button_pressed_after_short = 0.0
	
	
	#if position.x > 1000.0 or position.x < 0.0:
		#direction = !direction
	
	if direction:
		position.x += flying_speed * delta
	else:
		position.x -= flying_speed * delta
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			button_pressed.emit()
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			button_released.emit()


func button_just_pressed():
	button_is_pressed = true


print("short button press")
short_button_just_pressed = true


func button_just_released():
	if button_pressed_in_seconds > holding_threshold:
		print("long button press")
	elif button_pressed_in_seconds > 0.0:
		if short_button_just_pressed and button_pressed_after_short != 0.0 and button_pressed_after_short < double_press_threshold:
			print("double short button press")
		if !short_button_just_pressed
	
	button_is_pressed = false
