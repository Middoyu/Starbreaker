extends Node

var player = null
var crosshair = null
var player_gui = null
var camera = null

var main_manager = null


var current_stage = null
var current_stage_score := 0

var lvl_manager = null


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

