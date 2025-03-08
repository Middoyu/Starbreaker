extends Node

var player = Player
var crosshair = null
var player_gui = null
var camera = null

var main_manager = null

var boss_healthbar = null

var current_stage = null
var current_stage_score := 0
var EntityManager = null

var music_player = null

var button_audio = AudioStreamPlayer.new()

var lvl_manager = null
var has_viewed_tutorial = false

var is_pausable = false
var paused = false
var pause_menu = null
var mouse_state_before = null
var quit_value = 0

var projectile_z_index = 4000

var primary_selection = "Spray"
var utility_selection = "Zip-Dash"


const RELEASE_UI = preload("res://release_ui.tscn")

func _process(_delta: float) -> void:
	if is_pausable:
		pausing_sequence(_delta)

func _ready() -> void:
	var i = RELEASE_UI.instantiate()
	add_child(i)

func pausing_sequence(_delta):
	quit_value = clamp(quit_value, 0, 100)
	if pause_menu:
		pause_menu.quit_percentage.text = str(roundi(quit_value))
		if Input.is_action_pressed("primary") and paused:
			quit_value += 150 * _delta
		else:
			quit_value -= 250 * _delta
	if quit_value >= 99.8:
		main_manager.process_mode = PROCESS_MODE_ALWAYS
		main_manager.gameover_sequence(true)
		paused = false
		pause_menu.hide()
		
	if Input.is_action_just_pressed("quit"):
		paused = !paused
		match(paused):
			true:
				quit_value = 0
				main_manager.process_mode = PROCESS_MODE_DISABLED
				for i in get_children():
					if i != pause_menu:
						if i.has_method("paused"):
							i.paused()
				pause_menu.show()
				mouse_state_before = Input.get_mouse_mode()
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			false:
				main_manager.process_mode = PROCESS_MODE_ALWAYS
				for i in get_children():
					if i != pause_menu:
						i.process_mode = PROCESS_MODE_ALWAYS
				pause_menu.hide()
				Input.set_mouse_mode(mouse_state_before)

static func spawn_entity(path : PackedScene) -> Node:
	var path_instaniated = path.instantiate()
	global.EntityManager.add_child(path_instaniated)
	return path_instaniated

func clear_enemies():
	if is_instance_valid(current_stage):
		for i in global.EntityManager.get_children():
			if i is Enemy:
				if i.is_active == true:
					i.queue_free()
			if i is Projectile:
				i.queue_free()
			if i is Timer:
				if i.is_stopped() == false:
					i.queue_free()
