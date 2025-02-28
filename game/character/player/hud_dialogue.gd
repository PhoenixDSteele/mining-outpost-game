class_name HUD_Dialogue extends Control

@onready var subtitles: Label = %Subtitles
@onready var talker_portrait: TextureRect = %TalkerPortrait
@onready var talker_name: Label = %TalkerName
@onready var dialogue_audio: AudioStreamPlayer = %DialogueAudio
@onready var diag_anim: AnimationPlayer = $DiagAnimationPlayer
@onready var static_loop: AudioStreamPlayer = %StaticLoop
@onready var comm_start: AudioStreamPlayer = %CommStart

var curent_comm_diag : CommDialogue = null

var comm_active : bool = false

func play_comm_dialogue(comm_diag:CommDialogue):
	curent_comm_diag = comm_diag
	self.visible = true
	static_loop.play()
	for diag in curent_comm_diag.diag_array:
		comm_start.play()
		diag_anim.play("open_diag")
		talker_name.text = diag.talker
		subtitles.text = diag.talker + ": " + diag.dialogue
		talker_portrait.texture = diag.portrait
		dialogue_audio.stream = diag.audio
		dialogue_audio.play()
		await get_tree().create_timer(diag.audio.get_length()).timeout
	self.visible = false
	static_loop.stop()
