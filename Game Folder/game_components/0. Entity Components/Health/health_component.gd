extends Node
class_name HealthComponent

signal health_modified(damage_taken, colliding_hitbox)
signal death(damage_taken, colliding_hitbox)

@export var maximum_health = 100.0
@onready var current_health = maximum_health

func modify_health(amount := 0.0, colliding_hitbox = HitboxComponent):
	if current_health >= 0.0:
		current_health += amount
	current_health = clamp(current_health, 0.0, maximum_health)
	emit_signal("health_modified", amount, colliding_hitbox)
	check_death(amount, colliding_hitbox)
	print(current_health)

func check_death(amount := 0.0, colliding_hitbox = HitboxComponent):
	if current_health <= 0.0:
		emit_signal("death", amount, colliding_hitbox)
