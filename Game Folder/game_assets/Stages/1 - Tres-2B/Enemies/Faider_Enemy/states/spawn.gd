extends State

func enter():
	sprite.play("appear")
	await sprite.animation_finished
	Transistioned.emit(self, "attacking")
