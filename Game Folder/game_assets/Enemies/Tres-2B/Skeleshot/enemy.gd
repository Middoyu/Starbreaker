extends Enemy
#region Nodes
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var hitbox: HitboxComponent = $HitboxComponent

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var state_machine = $StateMachine
#endregion
@export var movement_speed = 4000.0

func _physics_process(_delta: float) -> void:
	move_and_slide()

#region Interaction Handlers
func on_hit(amount, colliding_hitbox) -> void:
	events.emit_signal("enemy_damaged", self)
	state_machine.current_state.Transistioned.emit(state_machine.current_state, state_machine.hit_state.name)
	score_event.update_score(OnHit_score * score_event.combo_multiplier)

func on_death(amount, colliding_hitbox) -> void:
	utility.play_isolated_audio(death_sfx_path, -3.0, true, "SFX")
	events.emit_signal("camera_shake", 35.0)
	events.emit_signal("enemy_killed", self)
	state_machine.current_state.Transistioned.emit(state_machine.current_state, state_machine.death_state.name)
	score_event.update_score(OnDeath_score * score_event.combo_multiplier)
#endregion
