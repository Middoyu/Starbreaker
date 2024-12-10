extends Entity
class_name Player
signal PlayerHit
signal PlayerDeath


#region State Variables
@export var is_moveable : bool = true
@export var is_actionable : bool = true
#endregion

#region Movement Variables
@onready var movement_speed : float
@export var max_movement_speed : float
@export var acceleration : float
@export var friction : float

#endregion

#region Visual Variables
@onready var player_sprite: AnimatedSprite2D = $Sprite
@onready var mvt_particles = null
const MVT_PARTICLES = preload("res://Game Folder/game_assets/Player/VFX/Movement Particles/mvt_particles.tscn")
@onready var game_over_black: ColorRect = $GameOverBlack
#endregion

#region Invincibility Variables
@onready var invincibility_timer := Timer.new()
@onready var invincibility_override : bool = false
@export var hit_invincibility_duration : float = 1.75
#endregion

#region Collision Variables
@onready var hurtbox: HurtboxComponent = $HurtboxComponent

#endregion

#region Weapons
const PRIMARY = preload("res://Game Folder/game_assets/Player/Weapons/1. Primary/Base/primary.tscn")
const SECONDARY = preload("res://Game Folder/game_assets/Player/Weapons/2. Secondary/Base/secondary.tscn")
const D_UTILITY = preload("res://Game Folder/game_assets/Player/Weapons/3. Utility/Base/defense_utility.tscn")
const MOVEMENT_UTILITY = preload("res://Game Folder/game_assets/Player/Weapons/3.5 Movement Utility/Base/Movement Utility.tscn")
const BREAKER = preload("res://Game Folder/game_assets/Player/Weapons/4. Breaker/breaker.tscn")
#endregion


#region SFX
@onready var normal_hit: AudioStreamPlayer = $SFX/Normal_Hit
@onready var strong_hit: AudioStreamPlayer = $SFX/Strong_Hit
@onready var dying_shatter: AudioStreamPlayer = $SFX/Dying_Shatter
#endregion



func _ready() -> void:
	setup_player()

#region Setup Functions
func setup_player():
	global.player = self
	setup_invincibility_timer()
	setup_weapons()
	setup_extra_vfx()
	setup_audio_listener()

func setup_invincibility_timer():
	# Invincibility Timer Load
	invincibility_timer.one_shot = true
	invincibility_timer.autostart = false
	invincibility_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	add_child(invincibility_timer, true)

func setup_weapons():
	var weapon_list = [PRIMARY.instantiate(), SECONDARY.instantiate(), BREAKER.instantiate(), MOVEMENT_UTILITY.instantiate()] # Missing D_UTILITY.instantiate()
	for weapon in weapon_list:
		add_child(weapon, true)
		weapon.player = self

func setup_extra_vfx():
	var effect_list = [MVT_PARTICLES.instantiate()]
	for effect in effect_list:
		if options.extra_vfx == true:
			add_child(effect, true)
			if effect.name == "MVT_Particles":
				mvt_particles = effect

func setup_audio_listener():
	var audio_listener = AudioListener2D.new()
	add_child(audio_listener, true)

#endregion



func _physics_process(delta: float) -> void:
	look_at_mouse()
	movement_handler(delta)
	invincibility_check()

func look_at_mouse():
	if is_moveable:
		look_at(get_global_mouse_position())
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



func death_sequence(finalblow_idenity):
	# Checks if the final attacker has a parent and reassigns the effects to the parent if so.
	if finalblow_idenity.parent:
		finalblow_idenity = finalblow_idenity.parent
	
	# Shifts the Z-Index of all the death associated parties.
	self.z_index = 4096
	finalblow_idenity.z_index = 4096
	finalblow_idenity.process_mode = Node.PROCESS_MODE_DISABLED
	finalblow_idenity.velocity = Vector2.ZERO
	
	# Clearing other entities & projectiles.
	for i in global.current_stage.get_children():
		if i is Entity:
			if i != self:
				if i != finalblow_idenity:
					i.queue_free()
		if i is Projectile:
			if i != finalblow_idenity:
				i.queue_free()
	for i in global.get_children():
		if i is Entity:
			if i != self:
				if i != finalblow_idenity:
					i.queue_free()
		if i is Projectile:
			if i != finalblow_idenity:
				i.queue_free()
	#global.crosshair.queue_free()
	
	# Repositions the black screen to cover the camera.
	game_over_black.show()
	game_over_black.reparent(global.current_stage)
	game_over_black.global_position = Vector2.ZERO
	game_over_black.rotation = 0.0
	game_over_black.play()
	
	
	
	
	# Normal effects.
	global.music_player.stop()
	global.camera.shake(65.0)
	$SFX/Strong_Hit.play()
	if options.extra_vfx:
		mvt_particles.queue_free()
		$Sprite/DeathEffects.emitting = true
	player_sprite.play("death")
	
	# Finish the sequence and pass it off to the main manager.
	await get_tree().create_timer(1.0).timeout
	$SFX/Dying_Shatter.play()
	await player_sprite.animation_finished
	global.main_manager.gameover_sequence()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func on_hit(damage_taken, colliding_hitbox) -> void:
	# If they have a parent connected to the hitbox.
	if colliding_hitbox.parent:
		var attacker = colliding_hitbox.parent
		# Can insert custom hints on the death screen.
		print_debug(attacker)
		# Damage taken, can modify if wanted.
		print_debug(damage_taken)
	
	# Resets the player's animation before starting the hit animation.
	player_sprite.stop()
	player_sprite.play("hit")
	
	# Gives the player invincibility time.
	invincibility_timer.start(hit_invincibility_duration)
	
	# Audio effects.
	normal_hit.play()
	
	# Visual effects.
	if global.camera:
		var camera = global.camera as juicycamera_component
		camera.shake(25.0)
		camera.freezeframe(0.01, 0.5)
		camera.flash()
	
	# Waits for the player sprite to finish it's animation before returning to idle.
	await player_sprite.animation_finished
	player_sprite.play("idle")


func on_death(damage_taken: Variant, colliding_hitbox: Variant) -> void:
	# Zero out the player.
	player_sprite.stop()
	hurtbox.is_disabled = true
	invincibility_override = true
	is_actionable = false
	is_moveable = false
	velocity = Vector2.ZERO
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	death_sequence(colliding_hitbox)

func invincibility_check():
	if invincibility_override == false:
		match invincibility_timer.time_left:
			0.0:
				hurtbox.is_disabled = false
			_:
				hurtbox.is_disabled = true
	elif invincibility_override == true:
		hurtbox.is_disabled = true
