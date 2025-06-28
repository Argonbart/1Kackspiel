extends Node2D


# nodes
@export var short_press_timer: Timer
@export var long_press_timer: Timer
@export var scoreText: Label
@export var highscore_table: Node2D
@export var hold_button: Node2D
@export var hold_button_progress_bar: TextureProgressBar

# variables
var time_when_button_was_pressed: float = Time.get_unix_time_from_system()
var time_when_button_was_released: float = Time.get_unix_time_from_system()
var currently_naming_score: bool = false
var waiting_for_release: bool = false
var score_already_saved: bool = false


func _ready():
	
	# set scores
	scoreText.text = str(Globals.score)
	highscore_table.load_score()
	
	# connect timers
	short_press_timer.connect("timeout", short_press_timer_timeout)
	long_press_timer.connect("timeout", long_press_timer_timeout)


func _process(_delta: float) -> void:
	
	# update progress bar
	if long_press_timer.time_left > 0 and not long_press_timer.is_stopped():
		hold_button_progress_bar.value = remap(long_press_timer.wait_time - long_press_timer.time_left, 0.0, long_press_timer.wait_time, 0.0, 100.0)


func _input(event: InputEvent) -> void:
	
	# scene inactive - ignore input
	if currently_naming_score:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			button_pressed()
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			button_released()


func short_press_timer_timeout():
	long_press_timer.start()


func long_press_timer_timeout():
	long_press_timer.stop()
	hold_button_progress_bar.value = 100.0
	swap_scene_to_name_score()


func button_pressed():
	short_press_timer.start()


func button_released():
	if short_press_timer.time_left > 0.0:
		short_press_input()
	if long_press_timer.time_left > 0.0:
		long_press_abort()


func short_press_input():
	GameStateManager.restart()
	call_deferred("queue_free")


func long_press_abort():
	long_press_timer.stop()
	create_tween().tween_property(hold_button_progress_bar, "value", 0, .2)


func swap_scene_to_name_score():
	
	# long press becomes invalid after score got saved once
	if score_already_saved:
		return
	
	# pan to other scene
	currently_naming_score = true
	create_tween().tween_property(get_parent(), "position", Vector2(-1152.0, 0.0), 1.0)
	await get_tree().create_timer(1.0).timeout
	get_parent().get_child(1).currently_naming_score = true
