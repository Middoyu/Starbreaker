extends Sprite2D
@export var max_radius = 165.0
@onready var mouse_crosshair: Sprite2D = $MouseCrosshair
@onready var crosshair_line: Line2D = $CrosshairLine


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN


func _process(delta: float) -> void:
	crosshair_line.points[0] = to_local(global.player.global_position)
	crosshair_line.points[1] = to_local(self.global_position)

func _physics_process(delta: float) -> void:
	
	mouse_crosshair.global_position = get_global_mouse_position()
	mouse_crosshair.rotation = owner.rotation
	
	rotation = owner.rotation
	if get_global_mouse_position().distance_to(owner.global_position) <= max_radius:
		global_position = get_global_mouse_position()
	else:
		var angle = owner.global_position.angle_to_point(get_global_mouse_position())
		global_position.x = owner.global_position.x + cos(angle) * max_radius
		global_position.y = owner.global_position.y + sin(angle) * max_radius
