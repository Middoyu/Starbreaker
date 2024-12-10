extends Node2D
class_name KnockbackComponent

signal is_taking_knockback(duration : float)

@export var parent : Node2D
@onready var latest_knockback_amount := 0.0
@onready var latest_knockback_stun_duration : float = 0.0
@export var recieves_knockback := true
@export var is_knockback_forced_upwards := true
@onready var knockback_timer := Timer.new()
@onready var knockback_direction := Vector2.ZERO
@export_range(0.0, 1.0) var armor_multiplier := 1.0

func _ready() -> void:
	knockback_setup()

#region Knockback Reactions
# Higher knockback amounts and lower stun duration results in a snappier knockback effect.
# Lower knockback amounts and higher stun durations are good a long knockback effect.

func knockback_setup():
	knockback_timer.one_shot = true
	add_child(knockback_timer)

func calculate_knockback(colliding_hitbox : HitboxComponent):
	## Grabs the knockback data from ther colliding hitbox.
	latest_knockback_amount = colliding_hitbox.knockback_amount
	knockback_direction = colliding_hitbox.global_position.direction_to(parent.global_position)
	## Starts the timer using the knockback duration.
	latest_knockback_stun_duration = colliding_hitbox.knockback_stun_duration
	knockback_timer.start(latest_knockback_stun_duration)
	emit_signal("is_taking_knockback", latest_knockback_stun_duration)


func apply_knockback(delta):
	## New knockback variables to consolidate the data.
	var knockback_velocity = Vector2.ZERO
	var knockback_scalar = 3.0
	## Multiplies the knockback direction to the amount.
	knockback_velocity = knockback_direction * latest_knockback_amount
	## Makes sure the knockback always sends upwards.
	if is_knockback_forced_upwards:
		knockback_velocity.y = -abs(knockback_velocity.y) * 1.3
		knockback_velocity.x /= 2.5
	## Applies the vector.
	parent.velocity = knockback_velocity * delta
	
	parent.move_and_slide()
	## Multiplies the knockback amount to the time left on the timer to create a smoothing effect.
	latest_knockback_amount *= knockback_timer.time_left * knockback_scalar * armor_multiplier

func check_knockback_process(delta):
	if knockback_timer.time_left > 0 and recieves_knockback == true:
		apply_knockback(delta)
#endregion
