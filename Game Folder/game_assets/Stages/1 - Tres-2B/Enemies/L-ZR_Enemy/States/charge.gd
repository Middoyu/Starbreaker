extends State
@onready var lazer_charge: AudioStreamPlayer2D = $lazer_charge


func enter():
	sprite.play("charge", 0.43)
	lazer_charge.playing = true
	await get_tree().create_timer(2.5).timeout
	Transistioned.emit(self, "firing")

func exit():
	lazer_charge.playing = false
