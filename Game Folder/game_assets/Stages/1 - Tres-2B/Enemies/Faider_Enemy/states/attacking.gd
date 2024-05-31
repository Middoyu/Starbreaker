extends State

var lowest_possible_delay := 0.25
var y_pos = -100.0
var max_teleport_amount = 5.0
var teleport_amount = 0.0
var timer_modifier = 0.0

func enter():
	move()
	$Timer.connect("timeout", timeout)

func move():
	sprite.play("teleport")
	await sprite.animation_finished
	sprite.play_backwards("teleport")
	if teleport_amount == max_teleport_amount - 1:
		y_pos = -100
		parent.global_position.y = parent.get_global_mouse_position().y + y_pos
		parent.global_position.x = parent.get_global_mouse_position().x
		teleport_amount = 0
		timer_modifier += 0.5
	else:
		teleport_amount += 1
		var position_rng = randf_range(-2.5, 2.5)
		parent.global_position.y = parent.get_global_mouse_position().y + y_pos
		parent.global_position.x = parent.get_global_mouse_position().x * position_rng
	$Timer.start()
	await sprite.animation_finished
	sprite.play("default")

func timeout() -> void:
	move()
	y_pos -= -100 / max_teleport_amount
	$Timer.wait_time = max(2.0 - timer_modifier, lowest_possible_delay)
	$Timer.start()
