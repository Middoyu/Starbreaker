extends Node

signal debug_skip()

#region Player Action/Reaction Signals
signal energy_updated(new_value)
signal player_damaged(current_health, damage_taken, colliding_hitbox)
signal player_death(damage_taken, colliding_hitbox)
signal player_healed(new_value)
signal no_hit(nohit_status)


#Firing Modes
signal shotgun_fired(projectile)

#endregion

#region Enemy Action/Reaction Signals

signal enemy_damaged(enemy)
signal enemy_killed(enemy)
signal boss_damaged(boss)

#endregion

#region Stage Action/Reaction Signals
signal stage_intro_finished
signal stage_started
signal stage_time(audio_time)
signal spawn_boss
signal boss_death
signal boss_spawning
signal GameOver(final_score)

# Tres-2B Special Events
signal enter_nullspace
signal tutorial_completed
signal skipped_tutorial
#endregion

#region Camera Signals
signal camera_shake(amount)
signal camera_zoom(zoom_amount, zoom_to_position, zoom_duration)
signal camera_freezeframe(amount, duration)
signal camera_flash()
#endregion
