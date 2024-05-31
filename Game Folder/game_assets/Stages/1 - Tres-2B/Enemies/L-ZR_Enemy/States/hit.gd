extends State

func enter():
	sprite.stop()
	sprite.play("hurt")
	parent.look_at(global.player.global_position)
	await sprite.animation_finished
	Transistioned.emit(self, "charge")
