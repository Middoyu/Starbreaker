extends Node2D
class_name StageBase
const HUD = preload("res://Game Folder/game_assets/Player/HUD/hud.tscn")
const CAMERA_BASE = preload("res://Game Folder/game_components/camera_component/Camera/camera_base.tscn")
const NAVIGATION_SPACE = preload("res://Game Folder/game_assets/Stages/00 - BASE/navigation_space.tscn")
const PLAYER = preload("res://Game Folder/game_assets/Player/Main/Player.tscn")

@export var end_time := 0.0

@onready var stage_started = false
@onready var is_boss_active = false

@onready var EntityManager = Node.new()

# Music
@export var stage_music: AudioStreamPlayer
@export var boss_music: AudioStreamPlayer

# Extra ARG
@onready var is_spawning = true
@export var player_starting_position := Vector2(320, 290)

func _ready() -> void:	
	add_child(EntityManager, true)
	global.EntityManager = EntityManager
	
	var hud = HUD.instantiate()
	var camera = CAMERA_BASE.instantiate()
	var nav_space = NAVIGATION_SPACE.instantiate()
	var player = PLAYER.instantiate()
	
	
	
	add_child(player)
	add_child(nav_space)
	add_child(camera)
	camera.reset_smoothing()
	add_child(hud)
	
	events.connect("player_death", stop_stage, 2)
	events.connect("debug_skip", skip_to, 0)
	
	add_wall_collision()
	
	global.player.global_position = player_starting_position
	global.current_stage = self

func start_stage():
	stage_started = true
	global.is_pausable = true
	events.emit_signal("stage_started")

func skip_to():
	stage_music.stop()
	stage_music.play(end_time)

#region Collisions


# Collisions & Obstacles
const WALL_COLLISIONS = preload("res://Game Folder/game_assets/Stages/00 - BASE/lvl_manager/walls/wall_collisions.tscn")

func add_wall_collision():
	var i = WALL_COLLISIONS.instantiate()
	add_child(i)
#endregion

func stop_stage(damage_taken, colliding_hitbox):
	for i in get_children():
		if i is AudioStreamPlayer:
			i.stop()
	stage_started = false
	is_boss_active = false
