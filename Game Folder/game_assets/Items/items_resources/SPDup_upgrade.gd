extends Base_Projectile_Upgrade
class_name SPD_Upgrade


@warning_ignore("unused_parameter")
func apply_upgrade(projectile : Projectile):
	projectile.speed *= 2
