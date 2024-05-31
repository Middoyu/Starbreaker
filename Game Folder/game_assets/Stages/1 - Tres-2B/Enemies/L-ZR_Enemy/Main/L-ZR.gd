extends Entity
@onready var texture: AnimatedSprite2D = $Texture
@onready var lazer_texture: AnimatedSprite2D = $Lazer/Lazer_Texture
@onready var hitbox: Hitbox = $Lazer/Hitbox
@export var death_anim_list : Array = ["death1", "death2", "death3"] 
@export_range(-1.0, 1.0, 0.01) var rotation_speed := 0.0
@onready var starting_rotation = special_data

func _ready() -> void: 
	hitbox.is_disabled = true
	starting_rotation = special_data
	rotation_degrees = starting_rotation
	lazer_texture.visible = false



func on_entity_hit(hitbox_data : HitboxData, attacker_position : Vector2):
	pass # Replace with function body.

func on_entity_death():
	pass # Replace with function body.
