class_name KeyPad extends Interactable
signal successful

@export var door : NormalDoor
@export var correct_code : int = 1337

@onready var button_01: ScreenButton = %BUTTON_01
@onready var button_02: ScreenButton = %BUTTON_02
@onready var button_03: ScreenButton = %BUTTON_03
@onready var button_04: ScreenButton = %BUTTON_04
@onready var button_05: ScreenButton = %BUTTON_05
@onready var button_06: ScreenButton = %BUTTON_06
@onready var button_07: ScreenButton = %BUTTON_07
@onready var button_08: ScreenButton = %BUTTON_08
@onready var button_09: ScreenButton = %BUTTON_09
@onready var button_00: ScreenButton = %BUTTON_00
@onready var button_del: ScreenButton = %BUTTON_DEL
@onready var button_ent: ScreenButton = %BUTTON_ENT

@onready var current_code_input: LineEdit = %CurrentCodeInput
@onready var correct_wrong_audio: AudioStreamPlayer = %CorrectWrongAudio

var processing : bool = false

const KEYPAD_RIGHT = preload("res://assets/audio/sfx/screen_sounds/keypad_right.wav")
const KEYPAD_WRONG = preload("res://assets/audio/sfx/screen_sounds/keypad_wrong.wav")

var powered : Powered
var powered_on : bool = false

@onready var screen: KeyPadScreen = $Screen
@onready var screen_camera: ScreenName = $ScreenCamera
var player_camera : Camera3D

var being_used : bool = false

func _ready() -> void:
	
	for node in self.get_children():
		if node is Powered:
			powered = node
			powered.powered_state.connect(toggle_power)
	
	button_01.pressed.connect(number_clicked.bind(button_01.name))
	button_02.pressed.connect(number_clicked.bind(button_02.name))
	button_03.pressed.connect(number_clicked.bind(button_03.name))
	button_04.pressed.connect(number_clicked.bind(button_04.name))
	button_05.pressed.connect(number_clicked.bind(button_05.name))
	button_06.pressed.connect(number_clicked.bind(button_06.name))
	button_07.pressed.connect(number_clicked.bind(button_07.name))
	button_08.pressed.connect(number_clicked.bind(button_08.name))
	button_09.pressed.connect(number_clicked.bind(button_09.name))
	button_00.pressed.connect(number_clicked.bind(button_00.name))
	button_del.pressed.connect(number_clicked.bind(button_del.name))
	button_ent.pressed.connect(number_clicked.bind(button_ent.name))

func number_clicked(button_name:String):
	if not processing:
		match button_name:
			button_01.name:
				update_code(1)
			button_02.name:
				update_code(2)
			button_03.name:
				update_code(3)
			button_04.name:
				update_code(4)
			button_05.name:
				update_code(5)
			button_06.name:
				update_code(6)
			button_07.name:
				update_code(7)
			button_08.name:
				update_code(8)
			button_09.name:
				update_code(9)
			button_00.name:
				update_code(0)
			button_del.name:
				update_code(69)
			button_ent.name:
				update_code(420)

func update_code(number:int):
	if current_code_input.text.length() >= 4:
		if number == 420:
			if current_code_input.text == str(correct_code):
				correct_wrong_audio.stream = KEYPAD_RIGHT
				correct_wrong_audio.play()
				process_code(true)
			else:
				correct_wrong_audio.stream = KEYPAD_WRONG
				correct_wrong_audio.play()
				process_code(false)
		if number == 69:
			current_code_input.text = current_code_input.text.left(current_code_input.text.length() - 1)
	else:
		if number == 69:
			current_code_input.text = current_code_input.text.left(current_code_input.text.length() - 1)
		elif number < 10:
			current_code_input.text = current_code_input.text + str(number)

func process_code(correct:bool):
	processing = true
	var default_color = current_code_input.get("theme_override_colors/font_uneditable_color")
	var t = get_tree().create_tween()
	if correct:
		t.tween_property(current_code_input, "theme_override_colors/font_uneditable_color", Color.GREEN, 0.1)
		t.tween_property(current_code_input, "theme_override_colors/font_uneditable_color", default_color, 0.1)
		t.tween_property(current_code_input, "theme_override_colors/font_uneditable_color", Color.GREEN, 0.1)
		t.tween_property(current_code_input, "theme_override_colors/font_uneditable_color", default_color, 0.1)
		t.tween_property(current_code_input, "theme_override_colors/font_uneditable_color", Color.GREEN, 0.1)
		t.tween_property(current_code_input, "theme_override_colors/font_uneditable_color", default_color, 0.1)
		t.tween_callback(func(): processing = false)
		t.tween_callback(func(): successful.emit())
		t.tween_callback(func(): current_code_input.text = "")
		door.toggle_lock(false)
		door._on_interacted()
	else:
		t.tween_property(current_code_input, "theme_override_colors/font_uneditable_color", Color.RED, 0.1)
		t.tween_property(current_code_input, "theme_override_colors/font_uneditable_color", default_color, 0.1)
		t.tween_property(current_code_input, "theme_override_colors/font_uneditable_color", Color.RED, 0.1)
		t.tween_property(current_code_input, "theme_override_colors/font_uneditable_color", default_color, 0.1)
		t.tween_property(current_code_input, "theme_override_colors/font_uneditable_color", Color.RED, 0.1)
		t.tween_property(current_code_input, "theme_override_colors/font_uneditable_color", default_color, 0.1)
		t.tween_callback(func(): processing = false)
		t.tween_callback(func(): current_code_input.text = "")

func toggle_power(power_state:bool) -> void:
	powered_on = power_state
	if not powered_on:
		screen.visible = false
		prompt_message = "NO POWER"
	elif powered_on:
		screen.visible = true
		prompt_message = "USE KEYPAD"

func _on_interacted() -> void:
	if not powered_on:
		return
	elif powered_on:
		swap_cameras()

func swap_cameras():
	player_camera = get_viewport().get_camera_3d()
	screen_camera.camera.make_current()
