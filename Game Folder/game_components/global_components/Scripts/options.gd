extends Node



var screenshake_enabled : bool = true
var displaydamage_enabled : bool = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_ready()
