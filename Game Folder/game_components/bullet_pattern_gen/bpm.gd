extends Node2D
class_name BulletPatternGenerator
signal shooting()
signal recharging()
signal before_shooting()

@export var bulletpath = load("res://Modules/Bullet Pattern Module/defaultbullet.tscn")

@onready var firerate_timer := Timer.new()
@onready var rotater := Node2D.new()
@export var firerate := 0.5
@export var rotation_speed := 100
@export var bullet_points := 4
@export var bullet_spawn_radius := 5 
@export var shoot_at_player := false
@export var automatically_fire := true

func _ready():
	rotatersetup()
	timersetup()

func _physics_process(delta):
	if shoot_at_player == false:
		rotate_rotater(delta)

func timersetup():
	add_child(firerate_timer);
	firerate_timer.one_shot = true;
	firerate_timer.wait_time = firerate;
	while !firerate_timer.is_connected("timeout", shoot):
		firerate_timer.connect("timeout", shoot);
		bulletsetup()
		break

func rotatersetup(): add_child(rotater)

func bulletsetup():
	var step = 2 * PI / bullet_points
	for i in range(bullet_points):
		var spawn_point = Node2D.new()
		var pos = Vector2(bullet_spawn_radius, 0).rotated(step * i)
		spawn_point.global_position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
	
	firerate_timer.wait_time = firerate
	if automatically_fire: firerate_timer.start()
	emit_signal("recharging")

func shoot():
	bulletsetup()
	for s in rotater.get_children():
		var bullet = bulletpath.instantiate()
		
		
		global.add_child(bullet)
		bullet.global_position = s.global_position
		bullet.rotation = s.global_rotation
		s.queue_free()
	bulletsetup()
	emit_signal("shooting")

func rotate_rotater(delta):
	var new_rotation = rotater.rotation_degrees + rotation_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)