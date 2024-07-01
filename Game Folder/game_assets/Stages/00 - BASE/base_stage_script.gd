extends Node2D
class_name StageBase

# Music variables
@export var music_WAV : AudioStreamWAV
@onready var music_player = AudioStreamPlayer.new()

# Enemy spawner variables
@export var enemy_list : Dictionary = {
	"EnemyScene": "res://Game Folder/game_assets/Enemies/Test_Enemy/enemy.tscn"
}
@export var enemy_spawnpoint_array : PackedVector2Array
@onready var enemy_spawn_timer = Timer.new()
@export var enemy_spawnrate := 1.5
@onready var enemy_spawn_count := 0

# Boss Variables
var is_boss_active = false


func _ready() -> void:
	global.current_stage = self
	mainloop_setup()
	music_setup()

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

func spawn_enemies(enemy_path : String, forced_spawnpoint := Vector2.ZERO):
	var enemy_int = load(enemy_path).instantiate() as Enemy
	
	if forced_spawnpoint != Vector2.ZERO:
		enemy_int.global_position = forced_spawnpoint
	#elif is_instance_valid(enemy_spawnpoint_array):
		#enemy_int.global_position = enemy_spawnpoint_array[randi_range(0, enemy_spawnpoint_array.size() - 1)]
	elif is_instance_valid(enemy_spawnpoint_array) and is_instance_valid(forced_spawnpoint) == false:
		push_error("Enemy spawnpoint isn't set.")
	
	add_child(enemy_int)

func music_setup():
	if is_instance_valid(music_WAV):
		add_child(music_player)
		music_player.stream = music_WAV
		music_player.volume_db = -14
		music_player.reparent(global.main_manager)
		music_player.play()
