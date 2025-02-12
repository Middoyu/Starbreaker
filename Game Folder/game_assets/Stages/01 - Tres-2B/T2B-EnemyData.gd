extends Resource
class_name EnemyData

@export var enemy_list = {
	# Placeholder Enemies
	"NULL_Placeholder": "res://Game Folder/game_assets/Enemies/0. NULL/PH Enemy/placeholder_enemy.tscn",
	# Tres-2B Enemies
	"Skeleshot": "res://Game Folder/game_assets/Enemies/Tres-2B/Skeleshot/enemy.tscn",
	"Skelazor": "res://Game Folder/game_assets/Enemies/Tres-2B/Skelazor/LZR_enemy.tscn",
	"Trishooter": "res://Game Folder/game_assets/Enemies/Tres-2B/Trishooter/trishooter.tscn",
	# W.I.P
	"Faider": "res://Game Folder/game_assets/Enemies/Tres-2B/The Faider/TheFaider.tscn",
	"Cosma-Turret": "res://Game Folder/game_assets/Enemies/Tres-2B/Cosma-Turret/cosmaturret.tscn",
	"Absorbio": "res://Game Folder/game_assets/Enemies/Tres-2B/Absorbio/Absorbio.tscn"
}

func load_cache():
	for i in enemy_list:
		cache.load_in_cache(enemy_list.get(i))
