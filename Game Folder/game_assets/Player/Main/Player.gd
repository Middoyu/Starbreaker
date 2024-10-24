extends Entity
class_name Player
signal PlayerHit
signal PlayerDeath

@onready var sprite: AnimatedSprite2D = $Sprite

@onready var is_moveable : bool
@onready var is_actionable : bool

#region MVT Variables
@onready var movement_speed : float
@export var max_movement_speed : float
@export var acceleration : float
@export var friction : float

@onready var mvt_particles = null
#endregion

@onready var player_sprite: AnimatedSprite2D = $Sprite

@onready var invincibility_timer := Timer.new()
@onready var invincibility_override : bool = false

@onready var hurtbox: Databox = $PlayerHurtbox

const PRIMARY = preload("res://Game Folder/game_assets/Player/Weapons/1. Primary/Base/primary.tscn")
const SECONDARY = preload("res://Game Folder/game_assets/Player/Weapons/2. Secondary/Base/secondary.tscn")
const D_UTILITY = preload("res://Game Folder/game_assets/Player/Weapons/3. Utility/Base/defense_utility.tscn")
const BREAKER = preload("res://Game Folder/game_assets/Player/Weapons/4. Breaker/breaker.tscn")

# Effects
const MVT_PARTICLES = preload("res://Game Folder/game_assets/Player/VFX/Movement Particles/mvt_particles.tscn")

func load_local_data():
	# Variable Setup
	is_moveable = true
	is_actionable = true
	# Invincibility Timer Load
	add_child(invincibility_timer, true)
	invincibility_timer.one_shot = true
	invincibility_timer.autostart = false
	invincibility_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	# Weapon Load
	var weapon_list = [PRIMARY.instantiate(), SECONDARY.instantiate(), D_UTILITY.instantiate(), BREAKER.instantiate()]
	for weapon in weapon_list:
		add_child(weapon, true)
		weapon.player = self
	var effect_list = [MVT_PARTICLES.instantiate()]
	for effect in effect_list:
		add_child(effect, true)
		if effect.name == "MVT_Particles":
			mvt_particles = effect
	# Audio Listener Load
	var audio_listener = AudioListener2D.new()
	add_child(audio_listener, true)

func _ready() -> void:
	setup_player()
	load_local_data()

func setup_player():
	global.player = self

func _physics_process(delta: float) -> void:
	movement_handler(delta)
	invincibility_check()

func movement_handler(delta):
	if is_moveable:
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
		if direction:
			movement_speed += acceleration * delta
		if not direction:
			movement_speed -= friction * delta
		movement_speed = clamp(movement_speed, 0.0, max_movement_speed)
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
	mvt_particles.queue_free()

func invincibility_check():
	if invincibility_override == false:
		match invincibility_timer.time_left:
			0.0:
				hurtbox.is_disabled = false
			_:
				hurtbox.is_disabled = true
	elif invincibility_override == true:
		hurtbox.is_disabled = true
