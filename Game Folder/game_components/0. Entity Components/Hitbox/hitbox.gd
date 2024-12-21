extends Area2D
class_name HitboxComponent

@export var parent : Node2D
@export var is_disabled := false
var hitbox_data := HitboxData.new() as HitboxData
@export var damage := 0.0
@export var knockback_amount := 0.0
@export var knockback_stun_duration : float = 0.0


#region Base Functions

func _physics_process(delta: float) -> void:
	set_groups()
	check_disable_mode_process()
	update_hitbox_data_process()

func _ready() -> void:
	change_debug_color(Color.RED)

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

## Aligns the hitbox data to the current stats of the databox.
func update_hitbox_data_process():
	hitbox_data.damage = damage
	hitbox_data.knockback_amount = knockback_amount
	hitbox_data.knockback_stun_duration = knockback_stun_duration
#endregion
