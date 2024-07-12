extends State


func _ready() -> void:
	events.connect("enemy_damaged", target_damaged, 1)
	events.connect("enemy_killed", target_died, 1)

func enter():
	if parent.current_target is Enemy:
		parent.current_target.hurtbox.is_locked_in = true
	parent.animation.play("Lock In")
	adapting_scale(parent.lockin_size)

func physics_update(delta):
	follow_target(parent.current_target)
	check_mouse_velocity()


#region Animation
func adapting_scale(lockin_size):
	parent.scale = Vector2(parent.lockin_size, parent.lockin_size)
#endregion

func follow_target(target):
	parent.global_position = target.global_position

func target_damaged(target : Node2D):
	pass

func target_died(target : Node2D):
	if target == parent.current_target:
		Transistioned.emit(self, "idle")


func check_mouse_velocity():
	if Input.is_action_just_pressed("ctrl"):
		Transistioned.emit(self, "idle")


func force_mouse():
	parent.get_window().warp_mouse(parent.global_position)

func exit():
	if parent.current_target is Enemy:
		parent.current_target.hurtbox.is_locked_in = false
		force_mouse()
		parent.animation.play_backwards("Lock In")
