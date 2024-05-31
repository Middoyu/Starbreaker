extends State

func get_random_value() -> int:
	parent.rng_value = randi_range(0, 1)
	return parent.rng_value

func action_timer_timeout() -> void:
	match get_random_value():
		0:
			Transistioned.emit(self, "SPAWN_ENEMY")
		1:
			Transistioned.emit(self, "SPAWN_ENEMY")
