class_name PauseScreen extends CanvasLayer
## Is instantiated via the 'Scene Manager', using the input on it.
##

@onready var exit_confirmation: Control = %ExitConfirmation
@onready var animation_player: AnimationPlayer = %AnimationPlayer

## Used to grab the previous gameplays music time to resume at correct time.
var stored_music_time : float = 0

## Pauses the game when it's instantiated in.
func _ready() -> void:
	# Plays swoosh sound for menu.
	AudioManager.play_UI_sound("swoosh")
	
	# Starts Menu Music.
	stored_music_time = AudioManager.music.get_playback_position()
	AudioManager.play_music("paused", AudioManager.stored_pause_music_time)
	
	get_tree().paused = true
	animation_player.play("slide_on_to_screen")

## Resume game. Unpauses the main node tree.
func resume_game() -> void:
	get_tree().paused = false
	AudioManager.stored_pause_music_time = AudioManager.music.get_playback_position()
	AudioManager.play_music("gameplay", stored_music_time)
	self.queue_free()

## Pops up exit confirmation.
func exit_game() -> void:
	exit_confirmation.visible = true

## Confirms exit, and takes play back main menu.
func confirm_exit() -> void:
	get_tree().paused = false
	SceneManager.to_main_menu()
	queue_free()

## Cancels exit, and takes play back a menu.
func cancel_exit() -> void:
	exit_confirmation.visible = false
