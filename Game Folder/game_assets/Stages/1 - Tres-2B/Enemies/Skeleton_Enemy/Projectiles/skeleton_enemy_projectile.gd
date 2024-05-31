extends Projectile

func _physics_process(delta: float) -> void:
	$Texture.rotate(100 * delta)
	velocity = spawn_angle * movement_speed
	move_and_slide()
