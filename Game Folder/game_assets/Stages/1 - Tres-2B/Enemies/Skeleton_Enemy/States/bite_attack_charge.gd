extends State

func enter():
	get_parent().player_vector = parent.get_player_vector()
	utils.spawn_rngpitch_audio("res://Stages/1 - Tres-2B/Enemies/Skeleton_Enemy/SFX/bite_attack/charge_bite.mp3")
	await get_tree().create_timer(0.5).timeout
	Transistioned.emit(self, "bite_attack")

