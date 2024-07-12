extends State

func physics_update(delta):
	move_crosshair(delta)
	parent.crosshair_lock.monitorable = true
	parent.crosshair_lock.monitoring = true

func _unhandled_input(event: InputEvent) -> void:
	switch_input_type(event)

#region Movement
func move_crosshair(delta):
	match parent.is_controller_active: # Switches movement type depending on this variable determined in the Input Switching region.
		true:
			follow_rstick(delta)
		false:
			follow_mouse(delta)

func follow_mouse(delta): # Makes the crosshair follow the mouse.
	parent.global_position = parent.get_global_mouse_position()

func follow_rstick(delta): # Makes the crosshair follow the right analog stick.
	var direction = Input.get_vector("rstick_left", 'rstick_right', "rstick_up", "rstick_down")
	parent.global_position += direction * parent.controller_crosshair_speed * delta
#endregion

#region Input Switching
func switch_input_type(event): # Switches the input type ON/OFF after pressing ENTER or START.
	if event.is_action_pressed("ui_accept"):
		match parent.is_controller_active:
			true:
				parent.is_controller_active = false
			false:
				parent.is_controller_active = true

#endregion

func area_entered(area: Area2D) -> void:
	if area is Databox:
		if area.can_be_locked_in == true:
			match area.team_affiliation:
				"EnemyTeam":
					parent.lockin_size = area.lockin_size
					parent.current_target = area.parent
					Transistioned.emit(self, "lock_in")
