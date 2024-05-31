extends State
@onready var bullet_filepath = preload("res://Stages/1 - Tres-2B/Enemies/Skeleton_Enemy/Projectiles/skeleton_enemy_projectile.tscn")

func enter():
	sprite.stop()
	sprite.play("shooting")
	effects()
	var i = bullet_filepath.instantiate() as Projectile
	i.global_position = parent.global_position
	get_tree().get_root().add_child(i)
	await get_tree().create_timer(0.45).timeout
	Transistioned.emit(self, "idle")

func effects():
	utils.spawn_rngpitch_audio("res://Stages/1 - Tres-2B/Enemies/Skeleton_Enemy/SFX/shoot/shooting_sfx.mp3", -8.0, 0.9, 1.1, "SFX")
	
	var k = parent.SHOOTING_EFFECTS.instantiate() as GPUParticles2D
	k.global_position = parent.global_position
	k.global_position.y += 5.25
	get_tree().get_root().add_child(k)
