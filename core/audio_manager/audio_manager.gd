extends Node
## AudioManager autoloaded.
## Used to manage all sounds in game.

## Dictionary of UI Sounds. Add more as needed.
var ui_sound_dict: Dictionary = {
	"highlight": preload("res://assets/audio/ui/ratchet_higlight_randomizer.tres"),
	"clicked": preload("res://assets/audio/ui/Button_Clicked.mp3"),
	"swoosh": preload("res://assets/audio/ui/Main_Ratchet_Up.mp3"),
}

## Reference to the music's [AudioStreamPlayer] node; All music played through this node for now.
@onready var music: AudioStreamPlayer = $Music
## Reference to the UI's [AudioStreamPlayer] node; All UI sounds played through this node for now.
@onready var ui: AudioStreamPlayer = $UI


## For keeping the pause music's resume time.
var stored_pause_music_time : float = 0

## Current Song
var current_song : String = ""

var volume_reduced : bool = false

func reduce_volume():
	if volume_reduced == false:
		volume_reduced = true
		music.volume_db -= 15

func restore_volume():
	if volume_reduced == true:
		volume_reduced = false
		music.volume_db += 15

## Current Song Syntax String List: 'main_menu', 'gameplay', 'paused', 'shop'.
func play_music(song_name:String, play_time:float = 0, volume:float = 0) -> void:
	current_song = song_name
	music.volume_db = volume
	music.stream = load(song_name)
	music.play(play_time)
	return

func stop_music():
	current_song = ""
	music.stop()

## Current UI Syntax String List: 'highlight', 'clicked', 'swoosh'.
func play_UI_sound(ui_sound_name:String, volume:float = 0) -> void:
	ui.volume_db = volume
	ui.stream = load(ui_sound_name)
	ui.play()
