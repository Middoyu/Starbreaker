extends Node
class_name State

@export var parent : Node2D
@export var is_state_cancelable := true
@export var sprite: AnimatedSprite2D
@onready var hit_state = get_parent().hit_state
@onready var death_state = get_parent().death_state

signal Transistioned

func cancel_action(_hitbox_data, _attacker_position):
	if is_state_cancelable:
		Transistioned.emit(self, hit_state.name)
		for i in self.get_children():
			if i is Timer:
				i.stop()

func cancel_action_to_death():
	if is_state_cancelable:
		Transistioned.emit(self, death_state.name)
		for i in self.get_children():
			if i is Timer:
				i.stop()


func enter():
	pass

func exit():
	pass

func update(_delta):
	pass

func physics_update(_delta):
	pass
