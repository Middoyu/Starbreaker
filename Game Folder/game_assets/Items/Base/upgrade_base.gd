extends Resource
class_name Base_Projectile_Upgrade

@export var texture : Texture2D = preload("res://Game Folder/game_assets/Player/Sprites/Player.png")
@export var text : String = "null"

@warning_ignore("unused_parameter")
func apply_upgrade(projectile : Projectile):
	## Override this function to apply upgrades to the projectile.
	pass
