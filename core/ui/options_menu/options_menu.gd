extends Control

## Signal triggered when exiting the menu
signal exit

@export_category("Video Controls")
@export var fullscreen_checkbox: CheckBox
@export_category("Audio Controls")
## Master audio bus volume slider
@export var master_vol_slider: HSlider
## Music audio bus volume slider
@export var music_vol_slider: HSlider
## SFX audio bus volume slider
@export var sfx_vol_slider: HSlider


func _ready() -> void:
	hide()
	fullscreen_checkbox.toggled.connect(_on_fullscreen_changed)
	master_vol_slider.value_changed.connect(_on_master_changed)
	music_vol_slider.value_changed.connect(_on_music_changed)
	sfx_vol_slider.value_changed.connect(_on_sfx_changed)

## Triggered upon entering the menu. Shows the menu and update the volume slider values 
func on_enter() -> void:
	visible = true
	# Video controls init
	var screen_type: Variant = SaveManager.config.get_value("video", "fullscreen")
	fullscreen_checkbox.button_pressed = true if screen_type == DisplayServer.WINDOW_MODE_FULLSCREEN else false
	# Audio controls init
	master_vol_slider.value = SaveManager.config.get_value("audio", str(AudioManager.BUS_MASTER_IDX))
	music_vol_slider.value = SaveManager.config.get_value("audio", str(AudioManager.BUS_MUSIC_IDX))
	sfx_vol_slider.value = SaveManager.config.get_value("audio", str(AudioManager.BUS_SFX_IDX))

#region VIDEO CONTROLS
## Triggered when the fullscreen checkbox toggled. Updates the screen mode.
func _on_fullscreen_changed(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		SaveManager.config.set_value("video", "fullscreen", DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		SaveManager.config.set_value("video", "fullscreen", DisplayServer.WINDOW_MODE_WINDOWED)
#endregion
#region AUDIO CONTROLS
## Triggered when the master volume slider value is changed. Updates the master audio bus volume.
func _on_master_changed(_value: float) -> void:
	set_volume(AudioManager.BUS_MASTER_IDX, master_vol_slider.value)
## Triggered when the music volume slider value is changed. Updates the music audio bus volume.
func _on_music_changed(_value: float) -> void:
	set_volume(AudioManager.BUS_MUSIC_IDX, music_vol_slider.value)
## Triggered when the sfx volume slider value is changed. Updates the sfx audio bus volume.
func _on_sfx_changed(_value: float) -> void:
	set_volume(AudioManager.BUS_SFX_IDX, sfx_vol_slider.value)
#endregion

## Sets the volume of the target audio bus index and saves the value in the config settings
func set_volume(idx: int, value: float) -> void:
	if value == 0.0: AudioServer.set_bus_volume_db(idx, -80.0)
	else: AudioServer.set_bus_volume_db(idx, AudioManager.lerp_to_db(value))
	SaveManager.config.set_value("audio", str(idx), value)

## Save the config to a file and exits the options menu
func _on_return_options_button_pressed() -> void:	
	SaveManager.save_config()
	visible = false
	exit.emit()
	
