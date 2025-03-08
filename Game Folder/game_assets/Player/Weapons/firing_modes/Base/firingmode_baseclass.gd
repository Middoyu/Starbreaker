extends Node
class_name Weapon

@onready var player = global.player
@onready var is_weapon_actionable : bool = true
@onready var cooldown_timer : Timer = Timer.new()

func _ready() -> void:
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	cooldown_timer.connect("timeout", func(): is_weapon_actionable = true)

func action():
	pass
