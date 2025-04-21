extends Entity
class_name Enemy

@onready var is_active = false
@export var auto_activate := false
@export var spawn_time = 0.0
@export var OnHit_score = 10
@export var OnDeath_score = 10

@export var hurt_sfx_path = "String"
@export var death_sfx_path = "String"



func _ready() -> void:
	if !auto_activate:
		hide()
		process_mode = ProcessMode.PROCESS_MODE_DISABLED
		events.connect("stage_time", appear, 1)

func appear(audio_time):
	audio_time = snappedf(audio_time, 0.1)
	if audio_time == spawn_time:
		show()
		is_active = true
		process_mode = ProcessMode.PROCESS_MODE_INHERIT
