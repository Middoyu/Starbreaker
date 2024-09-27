extends Node



#region Player Action/Reaction Signals
signal charge_updated(new_value)
signal player_damaged(new_value)
signal player_death
#endregion

#region Enemy Action/Reaction Signals

signal enemy_damaged(enemy)
signal enemy_killed(enemy)

#endregion

#region Stage Action/Reaction Signals
signal stage_intro_finished
signal boss_spawning
signal GameOver(final_score)
#endregion
