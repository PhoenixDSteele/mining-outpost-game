class_name HUD_Datapad extends Control


@onready var datapad_title: Label = %DatapadTitle
@onready var datapad_date: Label = %DatapadDate
@onready var datapad_text: Label = %DatapadText
@onready var datapad_audio: AudioStreamPlayer = %DatapadAudio

@onready var datapad_open: AudioStreamPlayer = %DatapadOpen

@onready var datapad_anim: AnimationPlayer = %DatapadAnimPlayer

var stored_datapad_time : float = 0
var datapad_active : bool = false

func open_data_pad(data:DataBase):
	AudioManager.reduce_volume()
	datapad_title.text = data.message_title
	datapad_date.text = data.message_date
	datapad_text.text = data.message_body
	datapad_audio.stream = data.audio
	datapad_audio.play()
	self.visible = true
	datapad_active = true
	datapad_anim.play("open_pad")
	datapad_open.play()
	await get_tree().create_timer(data.audio.get_length()).timeout
	if datapad_active:
		AudioManager.restore_volume()
		self.visible = false
		datapad_active = false

func pause_data_pad():
	stored_datapad_time = datapad_audio.get_playback_position()
	datapad_audio.stop()
	self.visible = false
	datapad_active = false
	
func resume_data_pad():
	AudioManager.reduce_volume()
	self.visible = true
	datapad_active = true
	datapad_anim.play("open_pad")
	datapad_open.play()
	await get_tree().create_timer(2.0).timeout
	datapad_audio.play(stored_datapad_time)
	await get_tree().create_timer(datapad_audio.stream.get_length() - stored_datapad_time).timeout
	AudioManager.restore_volume()
	self.visible = false
	datapad_active = false

func _on_button_pressed() -> void:
	self.visible = false
	datapad_audio.stop()
