extends Node2D
class_name StageBase

# Collisions & Obstacles
const WALL_COLLISIONS = preload("res://Game Folder/game_assets/Stages/00 - BASE/lvl_manager/walls/wall_collisions.tscn")


# Music
@onready var music_player = AudioStreamPlayer.new()
var audio_time = null

@export var TOKONEMU_MUSIC = ""
@export var MIDDOYU_MUSIC = ""

func load_stage_theme(): # Picks the song based on the OST Selection.
	match options.ost_selection:
		"Middoyu":
			#Insert Hardmode Code
			load_music_player(load(MIDDOYU_MUSIC) as AudioStreamWAV)
		"Tokonemu":
			#Insert Hardmode Code
			load_music_player(load(TOKONEMU_MUSIC) as AudioStreamWAV)

func load_music_player(loaded_music : AudioStreamWAV): # Creates a global music player to play the stage music on.
	global.music_player = music_player
	self.add_child(music_player)
	music_player.stream = loaded_music
	music_player.play()









# Enemy spawner variables
@export var enemy_list : Dictionary = {
	"EnemyScene": "res://Game Folder/game_assets/Enemies/0. NULL/PH Enemy/placeholder_enemy.tscn"
}
@export var enemy_spawnpoint_array : PackedVector2Array
@onready var enemy_spawn_timer = Timer.new()
@export var enemy_spawnrate := 1.5
@onready var enemy_spawn_count := 0
@onready var stage_started = false

# Boss Variables
var is_boss_active = false

@export var player_starting_position := Vector2.ZERO

func add_wall_collision():
	var i = WALL_COLLISIONS.instantiate()
	add_child(i)

func start():
	load_stage_theme()
	add_wall_collision()
	stage_started = true
	global.player.global_position = player_starting_position
	global.current_stage = self

func _ready() -> void:
	ResourceLoader.load_threaded_request("res://Game Folder/game_assets/Menus/MainMenu/GameOver/BASE/GameOver.tscn", "", true)
	pass

func _process(_delta: float) -> void:
	#audio_time = music_player.get_playback_position()
	pass

func mainloop_setup():
	add_child(enemy_spawn_timer)
	enemy_spawn_timer.wait_time = enemy_spawnrate
	enemy_spawn_timer.one_shot = false
	enemy_spawn_timer.connect("timeout", mainloop_spawning)
	enemy_spawn_timer.start()

func mainloop_spawning(_spawn_count := enemy_spawn_count):
	enemy_spawn_count += 1
	stage_specifc_spawns()

func stage_specifc_spawns():
	push_error("Spawning for " + str(enemy_spawn_count) + " not specified, unable to spawn enemies.")
	pass

func spawn_enemies(enemy_path : String, forced_spawnpoint := Vector2.ZERO, extra_arg_1 := 0.0, extra_arg_2 := 0.3):
	var enemy_int = load(enemy_path)
	enemy_int = enemy_int.instantiate()
	
	if forced_spawnpoint != Vector2.ZERO:
		enemy_int.global_position = forced_spawnpoint
	if enemy_path == "res://Game Folder/game_assets/Enemies/Tres-2B/Skelazor/LZR_enemy.tscn":
		enemy_int.spawn_rotation = extra_arg_1
		enemy_int.rotation_speed = extra_arg_2
	
	add_child(enemy_int)

func sync_music():
	if audio_time != null:
		audio_time = round(audio_time * 10) / 10
