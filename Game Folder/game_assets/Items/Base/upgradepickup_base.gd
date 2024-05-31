extends Area2D
class_name UpgradePickup_Base
@export var upgrade = Base_Projectile_Upgrade.new()
@export var pickup_texture = Texture2D

func _ready() -> void:
	connect("body_entered", _on_body_entered, 1)

func custom_addition():
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.upgrade_list.append(upgrade)
		custom_addition()
		utility.play_isolated_audio("res://Game Folder/game_assets/Items/Base/pickup.ogg", -16)
		queue_free()
