extends Node2D
class_name StageBase
@onready var music: AudioStreamPlayer = $Music
@onready var tutorial_music: AudioStreamPlayer = $Tutorial_Music
@onready var tutorial_transisition: AudioStreamPlayer = $Tutorial_Music/Tutorial_Transisition

#region Fade From Black
@onready var black: ColorRect = $Black

func intro():
	placeholder_cacheload()
	global.current_stage = self
	global.player.global_position = player_starting_position
	add_wall_collision()
	var i = create_tween().bind_node(black).set_ease(Tween.EASE_IN_OUT)
	i.tween_property(black, "color", Color(0,0,0,0), 0.5)
	await i.finished
	black.hide()
	
	if global.has_viewed_tutorial == false:
		tutorial_music.play()

#endregion

#region Collisions
# Collisions & Obstacles
const WALL_COLLISIONS = preload("res://Game Folder/game_assets/Stages/00 - BASE/lvl_manager/walls/wall_collisions.tscn")

func add_wall_collision():
	var i = WALL_COLLISIONS.instantiate()
	add_child(i)
#endregion

#region Music
@onready var stage_music_player = AudioStreamPlayer.new()
@onready var boss_music_player = AudioStreamPlayer.new()
var audio_time = 0.0
var current_audio_time = 0.0

func load_stage_music(loaded_music : AudioStreamWAV): # Creates a global music player to play the stage music on.
	global.music_player = stage_music_player
	self.add_child(stage_music_player, true)
	stage_music_player.stream = loaded_music
	stage_music_player.name = "STAGE_MUSICPLAYER"
	stage_music_player.volume_db = -10

func load_boss_music(loaded_music : AudioStreamWAV): # Creates a global music player to play the stage music on.
	self.add_child(boss_music_player, true)
	boss_music_player.stream = loaded_music
	boss_music_player.name = "BOSS_MUSICPLAYER"

func sync_music():
	if audio_time != null:
		audio_time = round(audio_time * 10) / 10
		current_audio_time = round(current_audio_time * 10) / 10
	
	if is_spawning and current_audio_time != audio_time: # If the zone is spawning, starting matching the music time.
		current_audio_time = audio_time
		if audio_time == tokonemu_spawn_times[clamp(spawn_interval, 0, tokonemu_spawn_times.size() - 1)]:
			spawn_enemies_pattern(spawn_patterns[clamp(spawn_interval, 0, spawn_patterns.size() - 1)])
			spawn_interval += 1


#endregion

#region Boss Variables

var is_boss_active = false
#endregion

#region Enemy Spawner Variables

@onready var is_spawning = true

@export var enemy_list : Dictionary = {
	# Placeholder Enemies
	"NULL_Placeholder": "res://Game Folder/game_assets/Enemies/0. NULL/PH Enemy/placeholder_enemy.tscn",
	# Tres-2B Enemies
	"Skeleshot": "res://Game Folder/game_assets/Enemies/Tres-2B/Skeleshot/enemy.tscn",
	"Skelazor": "res://Game Folder/game_assets/Enemies/Tres-2B/Skelazor/LZR_enemy.tscn",
	"Trishooter": "res://Game Folder/game_assets/Enemies/Tres-2B/Trishooter/trishooter.tscn",
	"Faider": "res://Game Folder/game_assets/Enemies/Tres-2B/The Faider/TheFaider.tscn",
	"Cosma-Turret": "res://Game Folder/game_assets/Enemies/Tres-2B/Cosma-Turret/cosmaturret.tscn",
	"Absorbio": "res://Game Folder/game_assets/Enemies/Tres-2B/Absorbio/Absorbio.tscn"
}

var spawn_interval = 0
@export var tokonemu_spawn_times = {0: 1.0}
@export var spawn_patterns = {0: 0}


func spawn_enemies(enemy_path : String, forced_spawnpoint := Vector2.ZERO, extra_arg_1 := 0.0, extra_arg_2 := 0.3):
	var enemy_int = load(enemy_path)
	enemy_int = enemy_int.instantiate()
	
	if forced_spawnpoint != Vector2.ZERO:
		enemy_int.global_position = forced_spawnpoint
	if enemy_path == "res://Game Folder/game_assets/Enemies/Tres-2B/Skelazor/LZR_enemy.tscn":
		enemy_int.spawn_rotation = extra_arg_1
		enemy_int.rotation_speed = extra_arg_2
	
	add_child(enemy_int)

# Handles the spawning of enemies based on the provided pattern
func spawn_enemies_pattern(pattern: int) -> void:
	# Set is_spawning to false to prevent immediate respawning
	is_spawning = true
	
	match pattern:
		0:
			# Spawn enemies at a specific position with a given scene
			spawn_enemies(enemy_list["Skeleshot"], Vector2(128, 64))
			spawn_enemies(enemy_list["Absorbio"], Vector2(128, 64))
			spawn_enemies(enemy_list["Skeleshot"], Vector2(512, -16))
		1:
			global.main_manager.gameover_sequence(false)

func placeholder_cacheload():
	cache.load_in_cache("res://Game Folder/game_assets/Enemies/Tres-2B/Skeleshot/enemy.tscn")
	cache.load_in_cache("res://Game Folder/game_assets/Enemies/Tres-2B/Skelazor/LZR_enemy.tscn")
	cache.load_in_cache("res://Game Folder/game_assets/Enemies/Tres-2B/The Faider/TheFaider.tscn")
	cache.load_in_cache("res://Game Folder/game_assets/Enemies/Tres-2B/Trishooter/trishooter.tscn")
	cache.load_in_cache("res://Game Folder/game_assets/Enemies/Tres-2B/King Timothy/skeleton_boss.tscn")
	cache.load_in_cache("res://Game Folder/game_assets/Stages/01 - Tres-2B/Obstacles/Gas Comets/Base/Gas Comets.tscn")
	cache.load_in_cache("res://Game Folder/game_assets/Enemies/Tres-2B/TutorialEnemy/Tutorial_Skeleshot.tscn")
	cache.load_in_cache("res://Game Folder/game_assets/Enemies/Tres-2B/Cosma-Turret/cosmaturret.tscn")
	cache.load_in_cache("res://Game Folder/game_assets/Enemies/Tres-2B/Absorbio/Absorbio.tscn")

#endregion

@onready var stage_started = false
@export var player_starting_position := Vector2()

func start_stage():
	stage_started = true
	global.is_pausable = true
	
	if global.has_viewed_tutorial == false: # If Player hasn't seen the tutorial.
		tutorial_transisition.play()
		tutorial_music.stop()
		await tutorial_transisition.finished
		tutorial_music.queue_free()
		music.play()
		events.emit_signal("stage_started")
	if global.has_viewed_tutorial == true: # If Player has seen the tutorial.
		tutorial_music.queue_free()
		music.play()
		events.emit_signal("stage_started")

func _process(_delta: float) -> void:
	audio_time = music.get_playback_position()
