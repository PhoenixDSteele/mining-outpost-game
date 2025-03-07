class_name cutscene_HUD extends Node

signal push_cutscene

@onready var cinematic_bars: Control = %CinematicBars
@onready var diag_box: Panel = %diag_box
@onready var continue_txt: Label = %ContinueTxt
@onready var speaker: Label = %Speaker
@onready var talker_portrait: TextureRect = %TalkerPortrait
@onready var subtitles: Label = %Subtitles
@onready var anim: AnimationPlayer = %AnimationPlayer
@onready var dialogue_audio: AudioStreamPlayer = $"../DialogueAudio"

var can_continue : bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_continue:
		push_cutscene.emit()
		anim.play("fade_in_diag")
		print("attempted cutscene push")

func update_information(portrait:Texture2D, speaker_name: String, dialogue:String, diag_audio:AudioStream = null):
	continue_txt.visible = false
	can_continue = false
	talker_portrait.texture = portrait
	subtitles.text = dialogue
	speaker.text = speaker_name
	if diag_audio != null:
		dialogue_audio.stream = diag_audio
		dialogue_audio.play()
		await get_tree().create_timer(dialogue_audio.stream.get_length()).timeout
		continue_txt.visible = true
		can_continue = true
	else:
		await get_tree().create_timer(1.0).timeout
		continue_txt.visible = true
		can_continue = true

func fade_in_bars():
	anim.play("fade_in_bars")

func fade_out_bars():
	anim.play("fade_out_bars")
