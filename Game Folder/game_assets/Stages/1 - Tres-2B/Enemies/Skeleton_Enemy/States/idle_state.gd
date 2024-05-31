extends State
@export var ai_navigation : NavigationAgent2D


func enter():
	sprite.play("idle")

func move():
	parent.velocity = parent.get_player_vector() * parent.mvt_speed
	parent.move_and_slide()

func physics_update(_delta):
	if is_instance_valid(global.player):
		ai_navigation.target_position = parent.get_global_mouse_position()
		var axis = parent.to_local(ai_navigation.get_next_path_position()).normalized()
		var intended_velocity = axis * parent.mvt_speed
		ai_navigation.set_velocity(intended_velocity)

func _on_ai_navigation_velocity_computed(safe_velocity: Vector2) -> void:
	if get_parent().current_state == self:
		parent.velocity = safe_velocity
		parent.move_and_slide()

func update(_delta):
	if is_instance_valid(global.player):
		if parent.action_cooldown.time_left <= 0.0:
			parent.action_cooldown.start(randf_range(5.0, 6.5))
			Transistioned.emit(self, "shoot_charge")
