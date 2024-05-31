extends State
@onready var hit_anim_list : Array = ["hit1", "hit2", "hit3"]
@onready var knockback_component: Node = $KnockbackComponent

func enter():
	sprite.stop()
	sprite.play(hit_anim_list.pick_random())

func physics_update(_delta):
	knockback_component.apply_knockback()
	if knockback_component.knockback_timer.time_left <= 0:
		Transistioned.emit(self, "hit_recovery")
	parent.move_and_slide()
