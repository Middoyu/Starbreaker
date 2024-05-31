extends State


func enter():
	pass

func physics_update(_delta):
	parent.velocity *= 0.65
	parent.move_and_slide()
	if parent.velocity.length() <= 0.1:
		Transistioned.emit(self, "idle")
