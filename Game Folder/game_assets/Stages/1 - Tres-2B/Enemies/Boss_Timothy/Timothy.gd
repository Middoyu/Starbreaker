extends Entity
class_name BossEntity
const SKELETON_ENEMY = preload("res://Stages/1 - Tres-2B/Enemies/Skeleton_Enemy/Main/Skeleton_Enemy.tscn")
@onready var rng_value = 0
@onready var action_timer: Timer = $ActionTimer

func play_intro():
	pass
