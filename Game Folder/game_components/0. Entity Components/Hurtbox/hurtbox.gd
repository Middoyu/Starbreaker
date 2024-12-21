extends Area2D
class_name HurtboxComponent
@export var parent : Node2D
@export var health : HealthComponent
@export var knockback : KnockbackComponent
@export var is_disabled := false

#region Base Functions
func _ready() -> void:
	connect("area_entered", area_entered, 1)

func _physics_process(delta: float) -> void:
	set_groups()
	check_disable_mode_process()
	change_debug_color(Color.AQUA)
	if knockback: 
		knockback.check_knockback_process(delta)

## Changes the debug color of the databox collisions.
func change_debug_color(color):
	for child in get_children():
		if child is CollisionShape2D:
			child.debug_color = color
			child.debug_color.a = 0.1
		if child is CollisionPolygon2D:
			pass

## Checks the disable mode for the databox. Appropriately changing the state depending on the is_disabled value.
func check_disable_mode_process():
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = is_disabled
		if child is CollisionPolygon2D:
			child.disabled = is_disabled

## Group changes.
func set_groups():
	if parent:
		for i in parent.get_groups():
			add_to_group(i)
#endregion

## Hurtbox reaction based on team affiliation.
func area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		if area.get_groups() != get_groups():
			health_reaction(area)
			knockback_reaction(area)
		if area.get_groups() == get_groups():
			pass

func health_reaction(area: Area2D):
	if health != null:
		health.modify_health(area.hitbox_data.damage, area)
	else:
		print_debug("Missing Health Component")

func knockback_reaction(area):
	if knockback != null:
		knockback.calculate_knockback(area)
	else:
		print_debug("Missing Knockback Component")
