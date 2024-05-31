extends Entity
@export var mvt_speed = 58.0
@onready var texture: AnimatedSprite2D = $Texture
@onready var is_offscreen = false
@onready var action_cooldown: Timer = $action_cooldown

const SHOOTING_EFFECTS = preload("res://Stages/1 - Tres-2B/Enemies/Skeleton_Enemy/Projectiles/effects/se_shooting_effects.tscn")

func _ready() -> void:
	action_cooldown.start(randf_range(3.5, 4.0))

func get_player_vector() -> Vector2:
	var player_direction_vector = (global.player.global_position - self.global_position).normalized()
	return player_direction_vector
