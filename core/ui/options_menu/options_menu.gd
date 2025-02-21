extends Control
## Signal triggered when exiting the menu
signal exit

#TODO Set Visual & Audio options in a seperate OptionsManager class

@export_category("Video Controls")
@export var fullscreen_checkbox: CheckBox
@export var resolution_options: OptionButton
@export_category("Audio Controls")
## Master audio bus volume slider
@export var master_vol_slider: HSlider
## Music audio bus volume slider
@export var music_vol_slider: HSlider
## SFX audio bus volume slider
@export var sfx_vol_slider: HSlider


func _ready() -> void:
	hide()
	

func _connect_signals() -> void:
	fullscreen_checkbox.toggled.connect(_on_fullscreen_changed)
	resolution_options.item_selected.connect(_on_resolution_changed)
	master_vol_slider.value_changed.connect(_on_master_changed)
	music_vol_slider.value_changed.connect(_on_music_changed)
	sfx_vol_slider.value_changed.connect(_on_sfx_changed)

func _disconnect_signals() -> void:
	fullscreen_checkbox.toggled.disconnect(_on_fullscreen_changed)
	resolution_options.item_selected.disconnect(_on_resolution_changed)
	master_vol_slider.value_changed.disconnect(_on_master_changed)
	music_vol_slider.value_changed.disconnect(_on_music_changed)
	sfx_vol_slider.value_changed.disconnect(_on_sfx_changed)

## Triggered upon entering the menu. Shows the menu and update the volume slider values 
func on_enter() -> void:
	visible = true
	# Video controls init
	fullscreen_checkbox.button_pressed = OptionsManager.fullscreen
	# Audio controls init
	master_vol_slider.value = OptionsManager.audio_volumes[OptionsManager.AudioBuses.MASTER]
	music_vol_slider.value = OptionsManager.audio_volumes[OptionsManager.AudioBuses.MUSIC]
	sfx_vol_slider.value = OptionsManager.audio_volumes[OptionsManager.AudioBuses.SFX]
	_connect_signals()

#region VIDEO CONTROLS
## Triggered when the fullscreen checkbox toggled. Updates the screen mode.
func _on_fullscreen_changed(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	elif not toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	OptionsManager.fullscreen = toggled_on
	OptionsManager.update_video()

func _on_resolution_changed(index: int) -> void:
	for res in OptionsManager.Resolutions.values():
		if res == index:
			OptionsManager.resolution = res
	OptionsManager.update_video()

#endregion
#region AUDIO CONTROLS
## Triggered when the master volume slider value is changed. Updates the master audio bus volume.
func _on_master_changed(_value: float) -> void:
	set_volume(OptionsManager.AudioBuses.MASTER, master_vol_slider.value)
## Triggered when the music volume slider value is changed. Updates the music audio bus volume.
func _on_music_changed(_value: float) -> void:
	set_volume(OptionsManager.AudioBuses.MUSIC, music_vol_slider.value)
## Triggered when the sfx volume slider value is changed. Updates the sfx audio bus volume.
func _on_sfx_changed(_value: float) -> void:
	set_volume(OptionsManager.AudioBuses.SFX, sfx_vol_slider.value)
#endregion

## Sets the volume of the target audio bus index and saves the value in the config settings
func set_volume(idx: int, value: float) -> void:
	OptionsManager.audio_volumes[idx] = value
	OptionsManager.update_audio()

## Save the config to a file and exits the options menu
func _on_return_options_button_pressed() -> void:
	_disconnect_signals()
	OptionsManager.save_config()
	visible = false
	exit.emit()
	
