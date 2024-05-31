extends State

func enter():
	await get_tree().create_timer(0.12).timeout
	Transistioned.emit(self, "bite_attack_recover")

func physics_update(_delta):
	charge_direction()
	parent.move_and_slide()
	parent.bite_hitbox.is_disabled = false

func exit():
	parent.bite_hitbox.is_disabled = true

func charge_direction():
	parent.velocity = get_parent().player_vector * 512
