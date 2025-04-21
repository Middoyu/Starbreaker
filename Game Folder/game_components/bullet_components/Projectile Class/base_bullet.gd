class_name Projectile
extends CharacterBody2D

@onready var parent = Node2D
@export var speed = 0.0
@export var hitbox : HitboxComponent
@onready var view_detector : VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()
@onready var deletion_timer = Timer.new()

func _ready():
	setup_screen_notifier()
	#self.add_to_group("Projectile")
	z_index = global.projectile_z_index
	deletion_timer.wait_time = 15.0
	deletion_timer.autostart = false
	deletion_timer.one_shot = true
	add_child(deletion_timer)
	deletion_timer.connect("timeout", func(): queue_free(), 0)

func setup_screen_notifier():
	self.add_child(view_detector)
	view_detector.rect = Rect2(Vector2(-100, -100), Vector2(200, 200))
	view_detector.screen_exited.connect(remove_from_tree)

func remove_from_tree():
	queue_free()
