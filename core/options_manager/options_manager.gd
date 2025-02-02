extends Node
## OptionsManager autoloaded.
## Used to manage loading and saving options/config settings

## AUDIO OPTIONS
## The total number of Audio Buses
const AUDIO_BUSES: int = 3
## Enumeration of all Audio Buses
enum AudioBuses {MASTER=0,MUSIC=1,SFX=2}

## VIDEO OPTIONS
## Enumeration of all included resolutions
enum Resolutions {FHD=0, HDPLUS=1, HDWXGA=2, WSVGA=3, nHD=4}
var resolution: Resolutions
var fullscreen: bool

var audio_volumes: Dictionary = {
	
}

const CONFIG_PATH: String = "user://settings.cfg"
var config: ConfigFile = ConfigFile.new()


func _ready() -> void:
	reset_config()
	load_config()

#region CONFIG CRUD OPERATIONS
func load_config() -> void:
	if config.load(CONFIG_PATH) == OK:
		load_video_config()
		load_audio_config()
	else: save_config()
	update_options()

func save_config() -> void:
	set_config()
	config.save(CONFIG_PATH)

## Reset config / options back to default
func reset_config() -> void:
	fullscreen = true if not OS.get_name() == "Web" else false
	resolution = Resolutions.FHD
	
	var default_volume:float = 0.5
	for i in range(AUDIO_BUSES):
		set_bus_volume(i, default_volume)
	set_config()
	

func set_config() -> void:
	config.set_value("video", "fullscreen", fullscreen)
	config.set_value("video", "resolution", resolution)
	for idx in range(AUDIO_BUSES):
		var volume:float = audio_volumes[idx]
		config.set_value("audio", str(idx), volume)

func load_video_config() -> void:
	fullscreen = config.get_value("video", "fullscreen")
	resolution = config.get_value("video", "resolution")


func load_audio_config() -> void:
	for i in range(AUDIO_BUSES):
		var volume: float = config.get_value("audio", str(i))
		set_bus_volume(i, volume)
#endregion
#region UPDATE FUNCTIONS
func update_options() -> void:
	update_video()
	update_audio()


func update_video() -> void:
	set_resolution()
	set_window_mode()


func update_audio() -> void:
	for i in range(AUDIO_BUSES):
		var volume: float = audio_volumes[i]
		set_bus_volume(i, volume)
#endregion
#region SET FUNCTIONS
func set_window_mode() -> void:
	var mode: DisplayServer.WindowMode = DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	if not fullscreen: mode = DisplayServer.WindowMode.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(mode)


func set_resolution() -> void:
	match resolution:
		Resolutions.FHD:
			DisplayServer.window_set_size(Vector2(1920,1080))
		Resolutions.HDPLUS:
			DisplayServer.window_set_size(Vector2(1600,900))
		Resolutions.HDWXGA:
			DisplayServer.window_set_size(Vector2(1280,720))
		Resolutions.WSVGA:
			DisplayServer.window_set_size(Vector2(1024,576))
		Resolutions.nHD:
			DisplayServer.window_set_size(Vector2(640,360))


func set_bus_volume(idx:int, value:float) -> void:
	audio_volumes[idx] = value
	var volume:float  = lerp_to_db(value)
	if value == 0.0:
		volume = -80
	AudioServer.set_bus_volume_db(idx, volume)
#endregion
#region HELPER FUNCTIONS	
## Convert options slider value to volume decibel.
func lerp_to_db(value: float) -> float:
	return clampf(lerp(-25.0, 25.0, value), -15.0, 5.0)
#endregion
