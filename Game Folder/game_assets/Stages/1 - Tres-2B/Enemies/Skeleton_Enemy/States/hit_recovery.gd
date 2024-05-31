extends State
@onready var timer = Timer.new()
@export var ai_navigation: NavigationAgent2D

func _ready() -> void:
	self.add_child(timer)
	timer.one_shot = true

func enter():
	timer.start(0.5)

func physics_update(_delta):
	parent.move_and_slide()
	if timer.time_left <= 0:
		ai_navigation.avoidance_enabled = true
		Transistioned.emit(self, "idle")
