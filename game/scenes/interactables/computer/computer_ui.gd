extends Control

@onready var text_edit: LineEdit = %TextEdit
@onready var enter_button: Button = %EnterButton
@onready var computer: ComputerScreen = $"../../.."

@onready var email: MarginContainer = $Email
@onready var login: Control = $Login

@onready var return_button: Button = $Email/VBoxContainer/ReturnButton

@onready var email_title_container: VBoxContainer = %EmailTitleContainer
const EMAIL_SUBJECT_BUTTON = preload("res://game/scenes/interactables/computer/email_subject_button.tscn")

@onready var message_title: Label = %MessageTitle
@onready var message_date: Label = %MessageDate
@onready var message_body: Label = $Email/VBoxContainer/HBoxContainer/VBoxContainer2/Panel/ScrollContainer/MarginContainer/MessageBody

@onready var audio: AudioStreamPlayer = %ComputerAudio
const CLICKED = preload("res://assets/audio/sfx/screen_sounds/keypad_clicked.wav")
const RIGHT = preload("res://assets/audio/sfx/screen_sounds/keypad_right.wav")
const WRONG = preload("res://assets/audio/sfx/screen_sounds/keypad_wrong.wav")

func _ready() -> void:
	populate_email_list()
	email_clicked(computer.data_array[0])

func populate_email_list():
	for data in computer.data_array:
		var email_instance : EmailSubjectButton = EMAIL_SUBJECT_BUTTON.instantiate()
		email_title_container.add_child(email_instance)
		email_instance.update_info(data)
		email_instance.email_title.pressed.connect(email_clicked.bind(email_instance.email_information))

func email_clicked(message_information:DataBase):
	audio.stream = CLICKED
	audio.play()
	message_title.text = message_information.message_title
	message_date.text = message_information.message_date
	message_body.text = message_information.message_body

func _on_enter_button_pressed() -> void:
	try_password()

func try_password():
	if text_edit.text == computer.login_password:
		audio.stream = RIGHT
		audio.play()
		open_email_screen()
	else:
		audio.stream = WRONG
		audio.play()
		text_edit.text = ""

func open_email_screen():
	text_edit.text = ""
	login.visible = false
	text_edit.editable = false
	email.visible = true

func return_to_login():
	login.visible = true
	text_edit.editable = true
	email.visible = false

func _on_text_edit_text_changed(_new_text: String) -> void:
	pass

func _on_text_edit_text_submitted(_new_text: String) -> void:
	try_password()

func _on_return_button_pressed() -> void:
	audio.stream = CLICKED
	audio.play()
	return_to_login()
