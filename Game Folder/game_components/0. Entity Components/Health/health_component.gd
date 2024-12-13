extends Node
class_name HealthComponent

signal health_modified(damage_taken, colliding_hitbox)
signal on_hit(damage_taken, colliding_hitbox)
signal on_heal(healing_recieved, colliding_hitbox)
signal death(damage_taken, colliding_hitbox)

@export var maximum_health = 100.0
@onready var current_health = maximum_health

func modify_health(amount := 0.0, _colliding_hitbox = HitboxComponent):
	if current_health >= 0.0:
		current_health += amount
	current_health = clamp(current_health, 0.0, maximum_health)
	
	if amount != abs(amount):
		emit_signal("on_hit", amount, _colliding_hitbox)
	else:
		emit_signal("on_heal", amount)
	
	check_death(amount, _colliding_hitbox)

func check_death(amount := 0.0, colliding_hitbox = HitboxComponent):
	if current_health <= 0.0:
		emit_signal("death", amount, colliding_hitbox)
