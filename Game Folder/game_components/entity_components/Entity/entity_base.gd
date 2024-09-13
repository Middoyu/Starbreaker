class_name Entity
extends CharacterBody2D

func get_player_vector() -> Vector2:
	var player_direction_vector = Vector2.ZERO
	if global.player:
		player_direction_vector = (utility.get_player().global_position - self.global_position).normalized()
	else:
		player_direction_vector = (get_global_mouse_position() - self.global_position).normalized()
	return player_direction_vector
