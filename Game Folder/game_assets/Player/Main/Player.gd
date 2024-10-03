extends Entity
class_name Player
signal PlayerHit
signal PlayerDeath
@onready var audio_listener: AudioListener2D = $AudioListener

@onready var is_moveable : bool = true
@onready var is_actionable : bool = true
@export var movement_speed : float = 10_000.0

@onready var player_sprite: AnimatedSprite2D = $Sprite

@onready var invincibility_override : bool = false
@onready var invincibility_timer: Timer = $InvincibilityTimer

@onready var hurtbox: Databox = $PlayerHurtbox


func _ready() -> void:
	setup_player()

func setup_player():
	global.player = self

func _physics_process(delta: float) -> void:
	audio_listener.global_position = self.global_position
	movement_handler(delta)
	invincibility_check()

func movement_handler(delta):
	if is_moveable:
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
		velocity = direction * movement_speed * delta
		move_and_slide()

func on_parent_hit(colliding_hitbox, damage_taken) -> void:
	hit_vfx()
	player_sprite.play("hit")
	invincibility_timer.start(1.0)
	await player_sprite.animation_finished
	player_sprite.play("idle")

func hit_vfx():
	if global.camera:
		var camera = global.camera as juicycamera_component
		camera.shake(25.0)
		camera.freezeframe(0.01, 0.3)

func on_parent_death(colliding_hitbox, damage_taken) -> void:
	player_sprite.play("death")
	handle_death()
	await player_sprite.animation_finished
	global.main_manager.gameover_sequence()

func handle_death():
	hurtbox.is_disabled = true
	invincibility_override = true
	is_actionable = false
	is_moveable = false

func invincibility_check():
	if invincibility_override == false:
		match invincibility_timer.time_left:
			0.0:
				hurtbox.is_disabled = false
			_:
				hurtbox.is_disabled = true
