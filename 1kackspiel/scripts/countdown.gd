extends MarginContainer

@export var timer:Timer 
@export var countdown_label:Label 
@export var score_label:Label 


var score_scene = preload("res://scenes/score_screen.tscn")

func _ready():
	start_game()


func start_game():
	Globals.countdown = 120
	Globals.score = 0
	if countdown_label:
		countdown_label.text = "%02d:%02d" % [Globals.countdown / 60, Globals.countdown % 60]
	if timer:
		timer.start()


func _process(_delta) -> void:
	if score_label:
		score_label.text = "Score: " + str(Globals.score)
	
	if Globals.countdown == 0:
		var score_instance = score_scene.instantiate()
		add_child(score_instance)
		#get_tree().paused = true



func _on_timer_timeout() -> void:
	Globals.countdown -= 1
	if countdown_label:
		countdown_label.text = "%02d:%02d" % [Globals.countdown / 60, Globals.countdown % 60]
