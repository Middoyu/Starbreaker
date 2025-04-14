extends Node
class_name HitFlashComponent

@export var target : Node
@export var health_component : HealthComponent
@export var duration := 0.07
@onready var flashShader = preload("res://Game Folder/game_assets/Shaders/flashshader.gdshader")
@onready var timer = Timer.new()

func _ready() -> void:
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", end_action, 0)
	health_component.connect("on_hit", func(damage_taken, colliding_hitbox): action(), 2)

func action():
	timer.stop()
	target.material = null
	print("action")
	target.material = ShaderMaterial.new()
	target.material.shader = flashShader
	target.material.set("shader_parameter/applied_effect", 0.65)
	timer.start(duration)

func end_action():
	target.material.set("shader_parameter/applied_effect", 0.0)
