extends Node


# Music Options
@export_enum("Middoyu", "Tokonemu") var ost_selection := "Tokonemu"


var screenshake_enabled : bool = true
var extra_vfx : bool = true
var bloom = 0.5
var screen_flash : bool = true

var displaydamage_enabled : bool = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_ready()
