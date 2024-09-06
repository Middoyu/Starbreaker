extends Button
class_name CustomButton

var audio_list = ["res://Game Folder/game_assets/Menus/SFX/buttons/block.ogg", "res://Game Folder/game_assets/Menus/SFX/buttons/cancel.ogg", "res://Game Folder/game_assets/Menus/SFX/buttons/click_on.ogg", "res://Game Folder/game_assets/Menus/SFX/buttons/hoverover.ogg", "res://Game Folder/game_assets/Menus/SFX/buttons/unlock.ogg"]

@onready var default_scale = scale
@onready var hover_scale = scale * 1.1

func load_in():
	for i in audio_list:
		cache.load_in_cache(i)
	action_mode = 0

func _ready() -> void:
	self.connect("focus_entered", hover_just_entered)
	self.connect("mouse_entered", hover_just_entered)
	load_in()

#region Audio
func load_audio():
	for i in audio_list:
		cache.load_in_cache(i)

func play_sound(sound):
	utility.play_isolated_audio(sound)
#endregion

func _process(delta: float) -> void:
	pivot_offset = size / 2
	if is_hovered():
		mouse_in()
	else:
		mouse_out()

#region Interaction
func mouse_in():
	var scale_tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	scale_tween.tween_property(self, "scale", hover_scale, 0.1)

func mouse_out():
	var scale_tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	scale_tween.tween_property(self, "scale", default_scale, 0.1)


func hover_just_entered():
	play_sound(audio_list[3])
#endregion
