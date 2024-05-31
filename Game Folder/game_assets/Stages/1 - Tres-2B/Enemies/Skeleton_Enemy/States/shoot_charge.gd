extends State

func enter():
	sprite.play("shoot_charge", 2.0)
	utils.spawn_audio("res://Stages/1 - Tres-2B/Enemies/Skeleton_Enemy/SFX/shoot/bone_charge_1sec.mp3", -6, 1.0, "SFX")
	await sprite.animation_finished
	Transistioned.emit(self, "shoot")
