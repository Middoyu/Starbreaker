extends Sprite2D
@export var max_radius = 165.0
@onready var mouse_crosshair: Sprite2D = $MouseCrosshair
@onready var crosshair_line: Line2D = $CrosshairLine
@onready var mouse_marker := $Marker
@onready var is_controller = false
@onready var controller_cursor_speed := 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN



func _process(delta: float) -> void:
	crosshair_line.points[0] = to_local(global.player.global_position)
	crosshair_line.points[1] = to_local(self.global_position)

func _physics_process(delta: float) -> void:
	
	
	if Input.is_action_just_pressed("controller_connect"):
		is_controller = true
	if Input.is_action_just_pressed("ctrl"):
		is_controller = false
	
	
	if is_controller:
		var direction = Input.get_vector("rstick_left", "rstick_right", "rstick_up", "rstick_down").normalized()
		if direction:
			controller_cursor_speed += 220.0
		else:
			controller_cursor_speed -= 250.0
		
		controller_cursor_speed = clampf(controller_cursor_speed, 0.0, 150)
		
		$CanvasLayer/Label.text = str(is_controller, controller_cursor_speed, direction)
		mouse_marker.velocity = lerp(mouse_marker.velocity, direction * controller_cursor_speed, delta * 50.0)
		mouse_marker.move_and_slide()
		owner.look_at(mouse_marker.global_position)
	else:
		mouse_marker.global_position = get_global_mouse_position()
		 
		
		mouse_crosshair.global_position = mouse_marker.global_position
		if mouse_marker.global_position.distance_to(owner.global_position) <= max_radius:
			global_position = mouse_marker.global_position
		else:
			var angle = owner.global_position.angle_to_point(mouse_marker.global_position)
			global_position.x = owner.global_position.x + cos(angle) * max_radius
			global_position.y = owner.global_position.y + sin(angle) * max_radius
		mouse_crosshair.rotation = owner.rotation
		rotation = owner.rotation
