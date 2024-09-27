extends Node
class_name ScoreManager_Component
@onready var score_display: Label = $ScoreLayout/ScoreDisplay
@onready var positional_coords: Marker2D = $ScoreLayout/Positional_Coords

func _ready() -> void:
	score_event.level_scoremanager = self
	score_event.score_display = score_display
