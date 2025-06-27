class_name Bird
extends Node2D


# constants
@export_category("Stats")
@export var FLYING_SPEED: float = 300.0
@export var Y_DIVE_DISTANCE: float = 300.0
@export var LONG_PRESS_TIME: float = 0.5		# time till press counts as long press
@export var DOUBLE_CLICK_TIME: float = 0.3		# time it waits for a second press after first short press
@export_category("Screen Boundries")
@export var LEFT_BOUNDRY: float = -5300.0
@export var RIGHT_BOUNDRY: float = 5300.0
@export_category("Nodes")
@export var bird_sprite: AnimatedSprite2D
@export var camera: Camera2D

# variables
var time_when_button_was_pressed: float = 0.0
var time_of_first_short_button_press: float = -1.0
var waiting_for_double_press: bool = false
var time_when_button_was_released: float = 0.0
var diving_neutral_y: float = 324.0
var diving_diff: float = 0.0
var currently_executing_command: bool = false


func _ready():
	Globals.invert_direction = false;


func _process(delta):
	position.x += FLYING_SPEED * delta * pow(-1, Globals.invert_direction)
	if position.x < LEFT_BOUNDRY or position.x > RIGHT_BOUNDRY:
		change_direction()
	position.y = diving_neutral_y + diving_diff
	camera.position.y = -diving_diff


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			button_pressed()
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			button_released()


func button_pressed():
	time_when_button_was_pressed = Time.get_unix_time_from_system()


func button_released():
	
	if currently_executing_command:
		return
	
	time_when_button_was_released = Time.get_unix_time_from_system()
	var held_duration = time_when_button_was_released - time_when_button_was_pressed
	if held_duration >= LONG_PRESS_TIME:
		currently_executing_command = true
		waiting_for_double_press = false
		dive()
	else:
		var time_since_first_short_button_press = time_when_button_was_released - time_of_first_short_button_press
		if waiting_for_double_press and time_since_first_short_button_press <= DOUBLE_CLICK_TIME:
			currently_executing_command = true
			waiting_for_double_press = false
			change_direction()
		else:
			waiting_for_double_press = true
			time_of_first_short_button_press = time_when_button_was_released
			await get_tree().create_timer(DOUBLE_CLICK_TIME).timeout
			if waiting_for_double_press:
				currently_executing_command = true
				waiting_for_double_press = false
				poop()


func dive():
	
	# start animation
	SoundManager.play_sound.emit("swoop")
	bird_sprite.play("dive_down")
	
	# stats
	var _DIVING_TIME_TO_REACH_BOTTOM: float = 0.6
	var _DIVIMG_TIME_SPENT_AT_BOTTOM: float = 0.2
	var _DIVING_TIME_TO_ROTATE: float = 0.3
	var _DIVING_TIME_TILL_ROTATE_BACK: float = 0.5
	
	# flying down part - takes _DIVING_TIME_TILL_ROTATE_BACK + _DIVING_TIME_TO_ROTATE = 0.8 sec
	var dive_tween1 = create_tween()
	dive_tween1.tween_property(self, "diving_diff", Y_DIVE_DISTANCE, _DIVING_TIME_TO_REACH_BOTTOM)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	var dive_tween2 = create_tween()
	dive_tween2.tween_property(bird_sprite, "rotation_degrees", pow(-1, Globals.invert_direction) * 45.0, _DIVING_TIME_TO_ROTATE)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(_DIVING_TIME_TILL_ROTATE_BACK).timeout
	var dive_tween3 = create_tween()
	dive_tween3.tween_property(bird_sprite, "rotation_degrees", 0.0, _DIVING_TIME_TO_ROTATE)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(_DIVING_TIME_TO_ROTATE).timeout
	
	# flying up part - takes _DIVING_TIME_TILL_ROTATE_BACK + _DIVING_TIME_TO_ROTATE = 0.8 sec
	var dive_tween4 = create_tween()
	dive_tween4.tween_property(self, "diving_diff", 0.0, _DIVING_TIME_TO_REACH_BOTTOM)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	var dive_tween5 = create_tween()
	dive_tween5.tween_property(bird_sprite, "rotation_degrees", pow(-1, Globals.invert_direction) * -45.0, _DIVING_TIME_TO_ROTATE)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(_DIVING_TIME_TILL_ROTATE_BACK).timeout
	var dive_tween6 = create_tween()
	dive_tween6.tween_property(bird_sprite, "rotation_degrees", 0.0, _DIVING_TIME_TO_ROTATE)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(_DIVING_TIME_TO_ROTATE).timeout
	
	# end animation
	bird_sprite.play("default")
	currently_executing_command = false


func change_direction():
	
	# start animation
	bird_sprite.play("turning")
	SoundManager.play_sound.emit("direction_change")
	
	Globals.invert_direction = !Globals.invert_direction
	bird_sprite.flip_h = !bird_sprite.flip_h
	await get_tree().create_timer(0.3).timeout
	
	# end animation
	bird_sprite.play("default")
	currently_executing_command = false


func poop():
	
	if AmmunitionManager.ammo_is_empty:
		currently_executing_command = false
		return
	
	if randi_range(0, 1):
		SoundManager.play_sound.emit("poop")
	
	AmmunitionManager.use_ammo.emit()
	currently_executing_command = false


func _on_bird_area_area_entered(area: Area2D) -> void:
	
	if area.get_groups().has("net"):
		GameStateManager.game_over()
	
	if area.get_groups().has("pick_up"):
		var picked_up_item: PickUp = area.get_parent()
		SoundManager.play_sound.emit("pickup")
		Globals.item_collected.emit(picked_up_item.poop_resource.poop_type)
		picked_up_item.queue_free()
