extends Node  # Base class Node
class_name HealthComponent  # Custom class for managing health system

signal health_modified(damage_taken, colliding_hitbox)  # Signal emitted when health is modified
signal on_hit(damage_taken, colliding_hitbox)  # Signal for when the entity takes damage
signal on_heal(healing_received, colliding_hitbox)  # Signal for healing
signal death(damage_taken, colliding_hitbox)  # Signal for when the entity dies

@export var maximum_health = 100.0  # The maximum health the entity can have
@onready var current_health = maximum_health  # The current health of the entity, initialized to maximum

# Function to modify the health amount
func modify_health(amount := 0.0, _colliding_hitbox = HitboxComponent) -> void:
	# Ensure health does not exceed maximum or go below zero
	if current_health >= 0.0:
		current_health += amount
	current_health = clamp(current_health, 0.0, maximum_health)
	
	# Emit appropriate signals based on whether the amount is positive or negative
	if amount < 0.0 and current_health > 0.0:
		emit_signal("on_hit", -amount, _colliding_hitbox)  # If damaged, emit "on_hit"
	
	elif amount > 0.0 and current_health > 0.0:
		emit_signal("on_heal", amount, _colliding_hitbox)  # If healed, emit "on_heal"
	
	check_death(amount, _colliding_hitbox)  # Check if health has dropped to zero

# Function to check if the entity has died
func check_death(amount := 0.0, colliding_hitbox = HitboxComponent) -> void:
	if current_health <= 0.0:
		emit_signal("death", amount, colliding_hitbox)  # Emit death signal if health is zero or less
