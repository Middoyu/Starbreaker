extends Entity  # Extend the base Entity class
class_name Player  # Set the class name as Player
signal PlayerHit  # Signal emitted when the player gets hit
signal PlayerDeath  # Signal emitted when the player dies

@onready var player_sprite: AnimatedSprite2D = $Sprite  # Reference to the player sprite

@onready var hurtbox: HurtboxComponent = $HurtboxComponent  # Reference to the Hurtbox component
@onready var health: HealthComponent = $"Health Manager"  # Reference to the Health component
@onready var physics: Node = $"Physics Manager"  # Reference to the Physics Manager
@onready var i_frames: Node = $"I-Frames Manager"  # Reference to the I-Frames Managerd
@onready var weapons: Node = $"Weapon Manager"  # Reference to the Weapon Manager
@onready var knockback: KnockbackComponent = $KnockbackComponent
@onready var crosshair: Sprite2D = $TrueCrosshair


func _ready() -> void:
	# Set up the player when the scene is ready
	setup_player()

func setup_player():
	global.player = self  # Set this player instance as the global player
	events.connect("stage_started", func(): physics.allows_input = true, 0)
	# Enable input when the stage starts

# Called when the player takes damage
func on_hit(damage_taken, colliding_hitbox) -> void:
	utility.play_isolated_audio("res://Game Folder/game_assets/Player/SFX/Hits/normal_hit.wav")
	
	events.emit_signal("player_damaged", health.current_health, damage_taken, colliding_hitbox)
	# Emit a signal for player damage, passing current health, damage taken, and the hitbox that caused the damage
	
	events.emit_signal("camera_shake", 25.0)
	# Trigger a camera shake effect
	events.emit_signal("camera_freezeframe", 0.01, 0.5)
	# Trigger a camera freeze effect (time, duration)
	events.emit_signal("camera_flash")
	# Trigger a camera flash effect

# Called when the player heals
func on_heal(healing_taken, _colliding_hitbox):
	events.emit_signal("player_healed", health.current_health)

func _process(delta: float) -> void:
	if Input.is_action_pressed("ctrl"):
		health.current_health += 100

# Called when the player dies
func on_death(damage_taken, colliding_hitbox) -> void:
	utility.play_isolated_audio("res://Game Folder/game_assets/Player/SFX/Hits/dying.wav")
	utility.play_isolated_audio("res://Game Folder/game_assets/Player/SFX/Hits/final_hit.wav")
	events.camera_flash.emit()
	global.clear_enemies()
	$Sprite/DeathEffects.emitting = true
	crosshair.queue_free()
	
	events.emit_signal("player_death", damage_taken, colliding_hitbox)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# Hide the mouse when the player dies
	# Emit a signal for player death, passing the damage taken and the hitbox that caused it
	await player_sprite.animation_finished
	global.main_manager.gameover_sequence(true)
