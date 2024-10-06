class_name Projectile
extends CharacterBody2D

@onready var parent = Node2D
@export var hitbox : Databox
@onready var view_detector : VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()

func _ready():
	setup_screen_notifier()
	self.add_to_group("Projectile")

func setup_screen_notifier():
	self.add_child(view_detector)
	view_detector.screen_exited.connect(remove_from_tree)

func remove_from_tree():
	queue_free()
