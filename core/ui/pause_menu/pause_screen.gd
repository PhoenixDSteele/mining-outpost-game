class_name PauseScreen extends CanvasLayer
## Is instantiated via the 'Scene Manager', using the input on it.
##
@onready var options_menu: Control = %OptionsMenu
@onready var debug_menu: Control = %DebugMenu
@onready var teleport_menu: Control = %TeleportMenu
@onready var power_menu: Control = %PowerMenu
@onready var exit_confirmation: Control = %ExitConfirmation
@onready var animation_player: AnimationPlayer = %AnimationPlayer

## Telport + Door ID Input. If ID is left blank, it will default to levels default spawn location.
@onready var level_teleport_input: LineEdit = %Level_Teleport_Input
@onready var door_id_teleport_input: LineEdit = %Door_ID_Teleport_Input


## Used to grab the previous gameplays music time to resume at correct time.
var stored_music_time : float = 0

## Unpaused currently playing song name.
var stored_song : String

## DEBUG POWER OPTION CONTAINER REFERENCE
@onready var manual_power_option_container: VBoxContainer = $Screen/PowerMenu/Panel2/VBoxContainer/ScrollContainer/ManualPowerOptionContainer
## MANUAL POWER OPTION Preload
const MANUAL_POWER_OPTION = preload("res://game/scenes/UI/debug/manual_power_option.tscn")

## Pauses the game when it's instantiated in.
func _ready() -> void:
	# Plays swoosh sound for menu.
	AudioManager.play_UI_sound(AudLib.ui.swoosh)
	
	# Starts Menu Music.
	stored_music_time = AudioManager.music.get_playback_position()
	stored_song = AudioManager.current_song
	AudioManager.play_music(AudLib.song.pause_theme, AudioManager.stored_pause_music_time)
	
	get_tree().paused = true
	animation_player.play("slide_on_to_screen")

## Resume game. Unpauses the main node tree.
func resume_game() -> void:
	get_tree().paused = false
	AudioManager.stored_pause_music_time = AudioManager.music.get_playback_position()
	AudioManager.play_music(stored_song, stored_music_time)
	self.queue_free()

## Pops up exit confirmation.
func exit_game() -> void:
	exit_confirmation.visible = true

## Confirms exit, and takes play back main menu.
func confirm_exit() -> void:
	get_tree().paused = false
	SceneManager.scene_change(SceneManager.level_main_menu)
	queue_free()

## Cancels exit, and takes play back a menu.
func cancel_exit() -> void:
	exit_confirmation.visible = false

## Opens OPTIONS MENU
func _on_options_button_pressed() -> void:
	options_menu.on_enter()

## Opens DEBUG MENU
func _on_debug_button_pressed() -> void:
	debug_menu.visible = true


## Opens Teleport Menu
func _on_teleport_button_pressed() -> void:
	teleport_menu.visible = true

## Closes DEBUG MENU
func _on_return_debug_button_pressed() -> void:
	debug_menu.visible = false

## Confirms teleport to location.
func _on_confirm_teleport_button_pressed() -> void:
	print(level_teleport_input.text)
	if SceneManager.known_scenes.has(level_teleport_input.text) == true:
		get_tree().paused = false
		if door_id_teleport_input.text != "":
			SceneManager.scene_change(level_teleport_input.text, door_id_teleport_input.text.to_int())
			queue_free()
		else:
			SceneManager.scene_change(level_teleport_input.text)
			queue_free()
	else:
		level_teleport_input.text = "NOT A VALID STRING"

## Closes Teleport Menu
func _on_return_teleport_button_pressed() -> void:
	level_teleport_input.clear()
	teleport_menu.visible = false

## Prevents strings being input that are not numbers.
func _on_door_id_teleport_input_text_changed(new_text: String) -> void:
	if new_text.is_valid_int() == false:
		door_id_teleport_input.text = ""


func _on_power_button_pressed() -> void:
	var debug_power_instance
	for area in GameInstance.powered_areas:
		debug_power_instance = MANUAL_POWER_OPTION.instantiate()
		manual_power_option_container.add_child(debug_power_instance)
		debug_power_instance.label.text = area
		debug_power_instance.toggle_state.connect(toggle_power_in_area)
		debug_power_instance.check_box.button_pressed = GameInstance.powered_areas[area]
		if GameInstance.powered_areas[area]:
			debug_power_instance.check_box.text = "ON"
		else:
			debug_power_instance.check_box.text = "OFF"
		print(area)
	power_menu.visible = true

func toggle_power_in_area(area_name:String, power_state:bool) -> void:
	GameInstance.powered_areas[area_name] = power_state
	if get_tree().current_scene is Level:
		get_tree().current_scene.check_powered_objects()

func _on_return_power_button_pressed() -> void:
	for child in manual_power_option_container.get_children():
		child.queue_free()
	power_menu.visible = false
