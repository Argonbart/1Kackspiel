extends MarginContainer


@export var one_second_timer: Timer 
@export var countdown_label: Label 
@export var score_label: Label 


func _ready():
	start_game_timer()


func start_game_timer():
	Globals.countdown = 120
	Globals.score = 0
	countdown_label.text = "%02d:%02d" % [Globals.countdown / 60.0, Globals.countdown % 60]
	one_second_timer.start()


func _process(_delta) -> void:
	
	score_label.text = "Score: " + str(Globals.score)
	
	if Globals.countdown == 0:
		GameStateManager.game_won()


func _on_timer_timeout() -> void:
	Globals.countdown -= 1
	countdown_label.text = "%02d:%02d" % [Globals.countdown / 60.0, Globals.countdown % 60]
