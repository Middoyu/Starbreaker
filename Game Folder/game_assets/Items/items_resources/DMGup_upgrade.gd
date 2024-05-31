extends Base_Projectile_Upgrade
class_name DMG_Upgrade

@warning_ignore("unused_parameter")
func apply_upgrade(projectile : Projectile):
	projectile.hitbox.damage *= 1.75
