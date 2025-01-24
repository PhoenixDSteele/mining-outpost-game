extends Node
## SaveManager autoloaded.
## Used to manage loading and saving data files.

const CONFIG_PATH: String = "user://settings.cfg"
const SAVE_PATH = "user://save_data.sav"
var config: ConfigFile = ConfigFile.new()

var new_save:bool = true
func _ready() -> void:
	# Game Data
	if FileAccess.file_exists(SAVE_PATH):
		load_data()
	else: reset_data()
	# Config Data
	reset_config()
	load_config()

#region Game Data
func load_data() -> void: pass
	##GameInstance.load_data()

func reset_data() -> void: pass
	##GameInstance.reset_data()

func save_game() -> void:
	var save_data: Dictionary = {}
	#save_data = GameInstance.get_data()
	FileAccess.open(SAVE_PATH, FileAccess.WRITE).store_string(var_to_str(save_data))
#region

#region Config
func load_config() -> void:
	if config.load(CONFIG_PATH) == OK:
		load_video_config()
		load_audio_config()
	else: save_config()


func save_config() -> void:
	config.save(CONFIG_PATH)

	
func reset_config() -> void:
	var window_mode: Variant = DisplayServer.WINDOW_MODE_FULLSCREEN
	if OS.get_name() == "Web": window_mode = DisplayServer.WINDOW_MODE_WINDOWED
	config.set_value("video", "fullscreen", window_mode)
	for i in range(AudioManager.AUDIO_BUSES):
		config.set_value("audio", str(i), 0.5)
		
	
func load_video_config() -> void:
	var screen_type: Variant = config.get_value("video", "fullscreen")
	DisplayServer.window_set_mode(screen_type)


func load_audio_config() -> void:
	for i in range(3):
		var value: float = config.get_value("audio", str(i))
		AudioServer.set_bus_volume_db(i, AudioManager.lerp_to_db(value))
#endregion
