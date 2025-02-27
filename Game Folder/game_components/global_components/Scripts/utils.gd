extends Node

func play_isolated_audio(audio : String, _volume : float = 0.0, _is_random := false): # Creates a isolated audio player and plays the audio. Should account for volume with the added vairable.
	# Creates the isolated nodes.
	var isolated_audio_player = AudioStreamPlayer.new()
	var isolated_audio_stream = AudioStream.new()
	
	# Loads the audio file by string.
	isolated_audio_stream = load(audio)
	isolated_audio_player.stream = isolated_audio_stream
	
	# Adds the player to the scene_tree
	add_child(isolated_audio_player)
	
	# Corrects the volume if it's changed.
	if _volume:
		isolated_audio_player.volume_db = _volume
	if _is_random:
		isolated_audio_player.pitch_scale = randf_range(0.8, 1.2)
	
	# Plays the audio, waits for it to finish before deleting.
	isolated_audio_player.play()
	await isolated_audio_player.finished
	isolated_audio_player.queue_free()

func get_player():
	return global.player

func get_crosshair():
	return global.crosshair

static func is_mouse_hidden(_is_mouse_hidden : bool): # Hides the mouse if value is true.
	match _is_mouse_hidden:
		true:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
		false:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func get_mouse_pos():
	return global.current_stage.get_global_mouse_position()



func _ready() -> void:
	for i in enemy_list:
		cache.load_in_cache(i)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_wipe") and OS.is_debug_build():
		events.camera_flash.emit()
		global.clear_enemies()
	if Input.is_action_just_pressed("heal") and OS.is_debug_build():
		global.player.health.modify_health(25)


@export var enemy_list = [
	# Placeholder Enemies
	"res://Game Folder/game_assets/Enemies/0. NULL/PH Enemy/placeholder_enemy.tscn", #0
	# Tres-2B Enemies
	"res://Game Folder/game_assets/Enemies/Tres-2B/Skeleshot/enemy.tscn", #1
	"res://Game Folder/game_assets/Enemies/Tres-2B/Skelazor/LZR_enemy.tscn", #2
	"res://Game Folder/game_assets/Enemies/Tres-2B/Trishooter/trishooter.tscn", #4
	# W.I.P
	"res://Game Folder/game_assets/Enemies/Tres-2B/The Faider/TheFaider.tscn", #5
	"res://Game Folder/game_assets/Enemies/Tres-2B/Cosma-Turret/cosmaturret.tscn", #6
	"res://Game Folder/game_assets/Enemiees/Tres-2B/Absorbio/Absorbio.tscn", #7
	"res://Game Folder/game_assets/Stages/01 - Tres-2B/Obstacles/asetroid_belt.tscn", #8
	"res://Game Folder/game_assets/Stages/01 - Tres-2B/Obstacles/asetroid.tscn" #9
	]
