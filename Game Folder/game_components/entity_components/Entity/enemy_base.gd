extends Entity
class_name Enemy

const XP_ORB = preload("res://Game Folder/game_assets/Stages/00 - BASE/lvl_manager/xp_orb/xp_orb.tscn")
const CHARGE_ORB = preload("res://Game Folder/game_assets/Stages/00 - BASE/lvl_manager/charge_orb/charge_orb.tscn")

func spawn_charge_orb(amount):
	var i = CHARGE_ORB.instantiate() as Entity
	i.global_position = global_position
	i.charge_amount = amount
	global.current_stage.add_child(i)

func spawn_xp_orb(amount):
	for orb in amount:
		var i = XP_ORB.instantiate() as Entity
		i.global_position = global_position
		i.xp_amount = 1
		global.current_stage.add_child(i)
