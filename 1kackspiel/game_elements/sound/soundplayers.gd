extends Node


func _ready():
	SoundManager.connect("play_sound", play_sound)


func play_sound(type: String):
	match type:
		"gurr":
			$GurrPlayer.play()
		"death":
			$DeathPlayer.play()
		"swoop":
			$SwoopPlayer.play()
		"pickup":
			$PickUpPlayer.play()
		"direction_change":
			$DirectionChangePlayer.play()
		"umbrella_destroyed":
			$UmbreallDestroyedPlayer.play()
		"poop":
			var r = randi_range(0,2)
			match r:
				1:
					$Poop1Player.play()
				2:
					$Poop2Player.play()
				3:
					$Poop3Player.play()
