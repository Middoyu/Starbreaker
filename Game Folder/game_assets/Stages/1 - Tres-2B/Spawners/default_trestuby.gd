extends Base_EnemySpawner

## Spawn Position Updates
func beat_update(_current_beat):
	match _current_beat:
		1:
			spawn_at_position(0, Vector2(128, 128))
