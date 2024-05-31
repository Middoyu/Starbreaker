extends State

func enter():
	sprite.play(parent.death_anim_list.pick_random())
	parent.hurtbox.is_disabled = true
	await sprite.animation_finished
	parent.queue_free()
