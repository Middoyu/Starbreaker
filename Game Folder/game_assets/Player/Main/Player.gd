extends Entity
class_name Player

#region Charge Variables
@onready var charge : float = 0.0:
	set(new_value):
		charge += new_value
		charge = clamp(charge, 0.0, 100.0)
		events.emit_signal("charge_updated", charge)
	get:
		return charge
#endregion
#region Animation Variables
@onready var player_sprite = $Sprite
#endregion
#region Collisions Variables
@onready var player_hurtbox: Databox = $PlayerHurtbox
#endregion
#region Movement & Actions Variables
@onready var is_moveable = true
@onready var is_actionable = true
@export var movenet_speed = 150
#endregion
#region Invincibility Variables
@onready var invincibility_override = false
@onready var invincibility_timer: Timer = $InvincibilityTimer
#endregion
#region Upgrades
@onready var upgrade_list : Array[Base_Projectile_Upgrade] = []
#endregion
#region Weapons Variables
@onready var primary = $Primary
@onready var secondary = $Secondary
@onready var util = $Utility
#endregion

func _ready() -> void:
	setup_player()

func setup_player():
	global.player = self

func _physics_process(delta: float) -> void:
	charge = 1 * delta
	input_detection(delta)
	invincibility_check()

#region Movement & Action Functions 
func input_detection(delta):
	if is_moveable:
		movement_handler()
	if is_actionable:
		if Input.is_action_pressed("primary"):
			primary.shoot()
		if Input.is_action_just_pressed("secondary"):
			secondary.shoot()
		if Input.is_action_just_pressed("movement_util"):
			util.teleport_action()
		if Input.is_action_just_pressed("ctrl"):
			global.main_manager.display_upgrade_UI()

func movement_handler():
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	velocity = direction * movenet_speed
	move_and_slide()
#endregion
#region Interaction Handlers
func on_parent_hit(colliding_hitbox) -> void:
	player_sprite.play("hit")
	invincibility_timer.start(1.0)

func on_parent_death(colliding_hitbox) -> void:
	player_sprite.play("death")
	handle_death()
	await player_sprite.animation_finished
	global.main_manager.gameover_sequence()

func handle_death():
	invincibility_override = true
	player_hurtbox.is_disabled = true
	is_actionable = false
	is_moveable = false

func invincibility_check():
	if invincibility_override == false:
		match invincibility_timer.time_left:
			0.0:
				player_hurtbox.is_disabled = false
			_:
				player_hurtbox.is_disabled = true

#endregion
