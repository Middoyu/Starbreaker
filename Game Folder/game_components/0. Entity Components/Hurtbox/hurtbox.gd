extends Area2D  # Inherit from Area2D

class_name HurtboxComponent  # Custom class name for better clarity

@export var parent : Node2D  # Reference to the parent node
@export var health : HealthComponent  # Health component reference
@export var knockback : KnockbackComponent  # Knockback component reference
@export var is_disabled := false  # Flag to disable the hurtbox

#region Base Functions

# Called when the node is ready
func _ready() -> void:
	connect("area_entered", area_entered, 1)  # Connect the area_entered signal

# Called every physics frame
func _physics_process(delta: float) -> void:
	set_groups()  # Update group membership
	check_disable_mode_process()  # Handle the disabled state logic
	change_debug_color(Color.AQUA)  # Change the debug collision color
	if knockback:
		knockback.check_knockback_process(delta)  # Handle knockback logic

# Changes the debug color of the CollisionShape2D and CollisionPolygon2D nodes
func change_debug_color(color: Color) -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.debug_color = color
			child.debug_color.a = 0.1  # Set transparency for debug color
		if child is CollisionPolygon2D:
			pass  # Do nothing for CollisionPolygon2D

# Checks the disabled mode for the hurtbox and updates collision shapes accordingly
func check_disable_mode_process() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = is_disabled  # Disable collision shapes if needed
		if child is CollisionPolygon2D:
			child.disabled = is_disabled  # Disable collision polygons if needed

# Updates the collision groups to match the parent’s groups
func set_groups() -> void:
	if parent:
		for group in parent.get_groups():
			add_to_group(group)  # Add the current node to all groups of the parent

#endregion  # End of Base Functions

# Handles collisions with other areas
func area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		if area.get_groups() != get_groups():
			health_reaction(area)  # Handle health reaction
			knockback_reaction(area)  # Handle knockback reaction
		else:
			pass  # Ignore collisions within the same group

# Handle health modification based on hitbox data
func health_reaction(area: Area2D) -> void:
	if health != null:
		health.modify_health(area.hitbox_data.damage, area)
	else:
		print_debug("Missing Health Component")  # Log if the HealthComponent is missing

# Handle knockback reactions
func knockback_reaction(area: Area2D) -> void:
	if knockback != null:
		knockback.calculate_knockback(area)
	else:
		print_debug("Missing Knockback Component")  # Log if the KnockbackComponent is missing
