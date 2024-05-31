extends State
@onready var death_anim_list : Array = ["death1", "death2", "death3", "death4", 'death5']


func enter():
	parent.action_cooldown.stop()
	utils.spawn_rngpitch_audio("res://Stages/1 - Tres-2B/Enemies/Skeleton_Enemy/SFX/noises/shattersfx.mp3", -8.0, 0.9, 1.1, "SFX")
	sprite.stop()
	sprite.play(death_anim_list.pick_random())
	parent.hurtbox.is_hurtboxes_disabled = true
	events.emit_signal("enemy_killed")
	await sprite.animation_finished
	parent.queue_free()
