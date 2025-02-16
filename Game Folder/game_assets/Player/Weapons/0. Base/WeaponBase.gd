extends Node
class_name WeaponBase

@export var player : Player
@onready var is_weapon_actionable : bool = true
@onready var cooldown_timer : Timer = Timer.new()

func _ready() -> void:
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	cooldown_timer.connect("timeout", func(): is_weapon_actionable = true)

func shoot():
	pass

func spawn_projectile(projectile_path):
	var proj_int = projectile_path.instantiate()
	proj_int.global_position = player.global_position
	global.EntityManager.add_child(proj_int)
