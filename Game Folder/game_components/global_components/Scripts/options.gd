extends Node



var screenshake_enabled : bool = true

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_ready()
