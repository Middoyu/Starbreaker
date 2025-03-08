class_name Projectile
extends CharacterBody2D

@onready var parent = Node2D
@export var speed = 0.0
@export var hitbox : HitboxComponent
@onready var view_detector : VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()

func _ready():
	setup_screen_notifier()
	#self.add_to_group("Projectile")
	z_index = global.projectile_z_index
	await get_tree().create_timer(15.0, false, true, false).timeout
	queue_free()

func setup_screen_notifier():
	self.add_child(view_detector)
	view_detector.rect = Rect2(Vector2(-100, -100), Vector2(200, 200))
	view_detector.screen_exited.connect(remove_from_tree)

func remove_from_tree():
	queue_free()
