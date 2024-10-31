extends Node


var score := 0
var high_score := 0
var level_scoremanager = null
var score_display = null

func update_score(amount):
	add_up_to_score(amount)

func passive_score_update(amount, delta):
	if is_instance_valid(global.current_stage):
		if global.current_stage and global.current_stage is StageBase:
			if global.current_stage.stage_started:
				score += amount * delta

func add_up_to_score(addition_threshold):
	for i in range(addition_threshold):
		score += 1
		await get_tree().create_timer(0.01, false, true, false).timeout
		if score == addition_threshold:
			break

func get_score_position() -> Vector2:
	if level_scoremanager:
		return level_scoremanager.positional_coords.global_position
	else:
		return Vector2.ZERO

func _physics_process(delta: float) -> void:
	if global.paused == false:
		passive_score_update(100, delta)

func _process(_delta: float) -> void:
	if is_instance_valid(score_display):
		score_display.text = str(score)
