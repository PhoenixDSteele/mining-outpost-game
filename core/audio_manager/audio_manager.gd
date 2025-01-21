extends Node
## AudioManager autoloaded.
## Used to manage all sounds in game.
##

## Dictionary of music. Add more as needed. Optionally add a constant below for auto-completion. Makes finding the song easier.
var music_dict: Dictionary = {
	"main_menu": preload("res://assets/audio/music/main_theme.mp3"),
	"paused": preload("res://assets/audio/music/BreathForAMoment.mp3"),
	"temp01": preload("res://assets/audio/music/CityRiff.mp3"),
	"temp02": preload("res://assets/audio/music/DustyEyes.mp3"),
	"temp03": preload("res://assets/audio/music/EnterTheForest.mp3"),
	"temp04": preload("res://assets/audio/music/RainCantStopTheBeat.mp3"),
	"temp05": preload("res://assets/audio/music/FearTheOre.mp3")
	
}
const music_main_menu : String = "main_menu" ## Main menu Music
const music_gameplay : String = "gameplay" ## Gameplay Music
const music_paused : String = "paused" ## Pause Music
const music_temp01 : String = "temp01" ## Temp Music 01
const music_temp02 : String = "temp02" ## Temp Music 02
const music_temp03 : String = "temp03" ## Temp Music 03
const music_temp04 : String = "temp04" ## Temp Music 04
const music_temp05 : String = "temp05" ## Temp Music 05

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
var current_song : String

## Current Song Syntax String List: 'main_menu', 'gameplay', 'paused', 'shop'.
func play_music(song_name:String, play_time:float = 0, volume:float = 0) -> void:
	current_song = song_name
	music.volume_db = volume
	music.stream = music_dict[song_name]
	music.play(play_time)
	return

## Current UI Syntax String List: 'highlight', 'clicked', 'swoosh'.
func play_UI_sound(ui_sound_name:String, volume:float = 0) -> void:
	ui.volume_db = volume
	ui.stream = ui_sound_dict[ui_sound_name]
	ui.play()
