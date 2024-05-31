extends Node


var score := 0
var high_score := 0
var score_display = null

func update_score(amount):
	score += amount
	if is_instance_valid(score_display):
		score_display.text = str(score)
