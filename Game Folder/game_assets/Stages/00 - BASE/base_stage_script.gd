extends Node2D
class_name StageBase

@onready var stage_started = false
@onready var is_boss_active = false

@onready var EntityManager = Node.new()

# Music
@export var stage_music: AudioStreamPlayer
@export var boss_music: AudioStreamPlayer
@onready var audio_time = 0.0
@onready var current_audio_time = 0.0

# Extra ARG
@onready var is_spawning = true
@export var player_starting_position := Vector2(320, 290)

@export var enemy_data := EnemyData.new()
@export var pattern_data := PatternSequence.new()

func _ready() -> void:
	enemy_data.load_cache()
	
	add_wall_collision()
	add_child(EntityManager, true)
	
	global.player.global_position = player_starting_position
	global.EntityManager = EntityManager
	global.current_stage = self

func start_stage():
	stage_started = true
	global.is_pausable = true
	events.emit_signal("stage_started")

func _process(_delta: float) -> void:
	audio_time = stage_music.get_playback_position()

#region Collisions


# Collisions & Obstacles
const WALL_COLLISIONS = preload("res://Game Folder/game_assets/Stages/00 - BASE/lvl_manager/walls/wall_collisions.tscn")

func add_wall_collision():
	var i = WALL_COLLISIONS.instantiate()
	add_child(i)
#endregion

#region Enemy Spawner Variables
func sync_music():
	if audio_time != null:
		audio_time = round(audio_time * 10) / 10
		current_audio_time = round(current_audio_time * 10) / 10
	
	if is_spawning and current_audio_time != audio_time: # If the zone is spawning, starting matching the music time.
		current_audio_time = audio_time
		if audio_time == pattern_data.spawn_times[clamp(pattern_data.spawn_interval, 0, pattern_data.spawn_times.size() - 1)]:
			spawn_enemies_pattern(pattern_data.spawn_patterns[clamp(pattern_data.spawn_interval, 0, pattern_data.spawn_patterns.size() - 1)])
			pattern_data.spawn_interval += 1

func spawn_enemies(enemy_path : String, forced_spawnpoint := Vector2.ZERO, _extra_arg_1 := 0.0, _extra_arg_2 := 0.0, _extra_arg_3 := 0.0):
	var enemy_int = load(enemy_path)
	enemy_int = enemy_int.instantiate()
	
	if forced_spawnpoint != Vector2.ZERO:
		enemy_int.global_position = forced_spawnpoint
	if enemy_path == "res://Game Folder/game_assets/Enemies/Tres-2B/Skelazor/LZR_enemy.tscn":
		enemy_int.spawn_rotation = _extra_arg_1
		enemy_int.rotation_speed = _extra_arg_2
	
	EntityManager.add_child(enemy_int, true)

# Handles the spawning of enemies based on the provided pattern
func spawn_enemies_pattern(pattern: int) -> void:
	# Set is_spawning to false to prevent immediate respawning
	is_spawning = true
	
	match pattern:
		-1:
			global.main_manager.gameover_sequence(false)
		0:
			spawn_enemies(enemy_data.enemy_list["Skeleshot"], Vector2(512, -16))
		1:
			spawn_enemies(enemy_data.enemy_list["Skeleshot"], Vector2(512, -16))

#endregion
