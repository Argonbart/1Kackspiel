extends Node2D


# loads
@export var short_press_timer: Timer
@export var long_press_timer: Timer
@export var dark_gray_stylebox: StyleBox
@export var gray_stylebox: StyleBox
@export var pink_stylebox: StyleBox
@export var text_color_selected: Color
@export var text_color_not_selected: Color

# nodes
@export var hbox: HBoxContainer
@export var score_text: RichTextLabel
var currently_selected: Panel = null
var currently_selected_idx: int = 0

# variables
var currently_naming_score: bool = false
var letters: Array = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
var letter_idx: Array = [0, 0, 0]

var save_file: Highscore


func _ready() -> void:
	
	# set all letters to A
	hbox.get_child(0).get_child(0).text = letters[0]
	hbox.get_child(1).get_child(0).text = letters[0]
	hbox.get_child(2).get_child(0).text = letters[0]
	hbox.get_child(3).get_child(0).text = "Confirm"
	
	# set first as selected
	currently_selected = hbox.get_child(currently_selected_idx)
	currently_selected.add_theme_stylebox_override("panel", pink_stylebox)
	currently_selected.get_child(0).add_theme_color_override("default_color", text_color_selected)
	currently_selected.get_child(2).visible = true
	
	# set other default colors
	hbox.get_child(1).add_theme_stylebox_override("panel", gray_stylebox)
	hbox.get_child(2).add_theme_stylebox_override("panel", gray_stylebox)
	hbox.get_child(3).add_theme_stylebox_override("panel", dark_gray_stylebox)
	hbox.get_child(1).get_child(0).add_theme_color_override("default_color", text_color_not_selected)
	hbox.get_child(2).get_child(0).add_theme_color_override("default_color", text_color_not_selected)
	hbox.get_child(3).get_child(0).add_theme_color_override("default_color", text_color_not_selected)
	hbox.get_child(1).get_child(2).visible = false
	hbox.get_child(2).get_child(2).visible = false
	hbox.get_child(3).get_child(2).visible = false
	
	# display score
	score_text.text = str(" Your Score: ", Globals.score)
	
	# connect timers
	short_press_timer.connect("timeout", short_press_timer_timeout)
	long_press_timer.connect("timeout", long_press_timer_timeout)
	
	# load highscore to save to
	save_file = load(str(OS.get_user_data_dir(), "/scores/highscore_data.tres"))


func _process(_delta: float) -> void:
	
	# update progress bar
	if long_press_timer.time_left > 0 and not long_press_timer.is_stopped():
		hbox.get_child(currently_selected_idx).get_child(1).value = remap(long_press_timer.wait_time - long_press_timer.time_left, 0.0, long_press_timer.wait_time, 0.0, 100.0)


func _input(event: InputEvent) -> void:
	
	# scene inactive - ignore input
	if !currently_naming_score:
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
	next_panel()


func button_pressed():
	short_press_timer.start()


func button_released():
	if short_press_timer.time_left > 0.0:
		short_press_input()
	if long_press_timer.time_left > 0.0:
		long_press_abort()


func short_press_input():
	short_press_timer.stop()
	if currently_selected_idx == 3:
		var new_name: String = str(hbox.get_child(0).get_child(0).text, hbox.get_child(1).get_child(0).text, hbox.get_child(2).get_child(0).text)
		var new_score: int = Globals.score
		save_file.add_new_score([new_name, new_score])
		var score_display_scene = get_parent().get_child(0)
		score_display_scene.highscore_table.load_score()
		score_display_scene.score_already_saved = true
		score_display_scene.hold_button.visible = false
		currently_naming_score = false
		create_tween().tween_property(get_parent(), "position", Vector2(0.0, 0.0), 1.0)
		await get_tree().create_timer(1.0).timeout
		score_display_scene.currently_naming_score = false
	else:
		letter_idx[currently_selected_idx] = (letter_idx[currently_selected_idx] + 1) % letters.size()
		hbox.get_child(currently_selected_idx).get_child(0).text = letters[letter_idx[currently_selected_idx]]


func long_press_abort():
	long_press_timer.stop()
	create_tween().tween_property(hbox.get_child(currently_selected_idx).get_child(1), "value", 0, .2)


func next_panel():
	hbox.get_child(currently_selected_idx).get_child(1).value = 0.0
	if currently_selected_idx == 3:
		hbox.get_child(3).add_theme_stylebox_override("panel", dark_gray_stylebox)
	else:
		currently_selected.add_theme_stylebox_override("panel", gray_stylebox)
	currently_selected.get_child(0).add_theme_color_override("default_color", text_color_not_selected)
	currently_selected.get_child(2).visible = false
	currently_selected_idx = (currently_selected_idx + 1) % hbox.get_children().size()
	currently_selected = hbox.get_child(currently_selected_idx)
	currently_selected.add_theme_stylebox_override("panel", pink_stylebox)
	currently_selected.get_child(0).add_theme_color_override("default_color", text_color_selected)
	currently_selected.get_child(2).visible = true
