extends State


func enter():
	sprite.play("appear")
	await get_tree().create_timer(0.5).timeout
	Transistioned.emit(self, "charge")
