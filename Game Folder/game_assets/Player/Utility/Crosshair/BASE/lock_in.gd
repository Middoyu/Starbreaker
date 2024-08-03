extends State
@onready var lock_in: AudioStreamPlayer2D = $"../../LockIn"
@onready var lock_out: AudioStreamPlayer2D = $"../../LockOut"
@onready var mouse_detection: Area2D = $"../../Mouse_Detection"
var damage_stutter_fix = false
@onready var damage_stutter_fix_timer: Timer = $"../../DamageStutterFix"

func _ready() -> void:
	events.connect("enemy_damaged", target_damaged, 1)
	events.connect("enemy_killed", target_died, 1)

func enter():
	lock_out.stop()
	lock_in.play()
	parent.get_window().warp_mouse(parent.current_target.global_position)
	if parent.current_target is Enemy:
		parent.current_target.hurtbox.is_locked_in = true
	parent.animation.play("Lock In")
	adapting_scale(parent.lockin_size)

func physics_update(delta):
	follow_target(parent.current_target)
	parent.crosshair_lock.monitorable = false
	parent.crosshair_lock.monitoring = false

func update(delta):
	if Input.get_last_mouse_velocity() == Vector2.ZERO:
		parent.get_window().warp_mouse(parent.current_target.global_position)

#region Animation
func adapting_scale(lockin_size):
	parent.scale = Vector2(parent.lockin_size, parent.lockin_size)
#endregion

func follow_target(target):
	parent.global_position = target.global_position

func target_damaged(target : Node2D):
	if is_same(target, parent.current_target):
		damage_stutter_fix = true
		damage_stutter_fix_timer.start(0.1)
		parent.spawn_particles()
		target.spawn_charge_orb(5)

func target_died(target : Node2D):
	if is_same(target, parent.current_target):
		Transistioned.emit(self, "idle")
		force_mouse()

func force_mouse():
	parent.get_window().warp_mouse(parent.global_position)

func exit():
	lock_in.stop()
	lock_out.play()
	parent.current_target.hurtbox.is_locked_in = false
	parent.animation.play("Lock Out")
	parent.scale = Vector2.ONE
	parent.rotation_degrees = 0.0
	parent.current_target = null

func mouse_exited() -> void:
	if damage_stutter_fix == false:
		Transistioned.emit(self, "idle")

func stutter_fix_timeout() -> void:
	damage_stutter_fix = false
