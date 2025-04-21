extends Area2D  # Inherits from Area2D, appropriate for 2D collision handling

class_name HitboxComponent  # Class name for better code clarity

@export var parent : Node2D  # Parent node to which this component belongs
@export var is_disabled := false  # Flag to disable or enable the hitbox
var hitbox_data := HitboxData.new() as HitboxData  # Data structure to hold hitbox properties
@export var damage := 0.0  # Damage value for the hitbox
@export var knockback_amount := 0.0  # Knockback force of the hitbox
@export var knockback_stun_duration : float = 0.0  # Duration of knockback stun

#region Base Functions

func _physics_process(delta: float) -> void:
	set_groups()  # Update the group memberships
	check_disable_mode_process()  # Handle the enabled/disabled state of the hitbox
	update_hitbox_data_process()  # Sync hitbox data with component properties

func _ready() -> void:
	change_debug_color(Color.RED)  # Set the debug color of collision shapes
	check_disable_mode_process()

## Changes the debug color of the hitbox collision shapes.
func change_debug_color(color):
	for child in get_children():
		if child is CollisionShape2D:
			child.debug_color = color  # Set debug color for CollisionShape2D
			child.debug_color.a = 0.1  # Set transparency for debugging
		if child is CollisionPolygon2D:
			pass  # No action for CollisionPolygon2D

## Checks the disable mode and applies it to collision shapes as needed.
func check_disable_mode_process():
	self.monitorable = !is_disabled
	self.monitoring = !is_disabled
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = is_disabled  # Enable/disable based on is_disabled flags
		if child is CollisionPolygon2D:
			child.disabled = is_disabled  # Enable/disable based on is_disabled flag

## Updates the hitbox data based on the current properties of this component.
func set_groups():
	if parent:
		for group in parent.get_groups():
			add_to_group(group)

## Aligns the hitbox data with the current properties of this component.
func update_hitbox_data_process():
	hitbox_data.damage = damage  # Update damage
	hitbox_data.knockback_amount = knockback_amount  # Update knockback amount
	hitbox_data.knockback_stun_duration = knockback_stun_duration  # Update stun duration
#endregion
