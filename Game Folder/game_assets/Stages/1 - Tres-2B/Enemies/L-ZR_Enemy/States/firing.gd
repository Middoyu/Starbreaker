extends State
@onready var lazer_fire: AudioStreamPlayer2D = $lazer_fire
@onready var lazer_hum: AudioStreamPlayer2D = $lazer_hum
@onready var particles: GPUParticles2D = $"../../Lazer/Particles"

func _ready() -> void:
	particles.emitting = false

func enter():
	lazer_fire.play()
	particles.emitting = true
	parent.lazer_texture.visible = true
	parent.lazer_texture.play("idle")
	parent.hitbox.is_disabled = false
	lazer_hum.playing = true

func exit():
	particles.emitting = false
	lazer_hum.playing = false
	parent.lazer_texture.visible = false
	parent.hitbox.is_disabled = true

func physics_update(delta):
	parent.global_rotation_degrees -= parent.rotation_speed * 100 * delta
