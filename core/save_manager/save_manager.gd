extends Node
## SaveManager autoloaded.
## Used to manage loading game save data.

const SAVE_PATH = "user://save_data.sav"


var new_save:bool = true
func _ready() -> void:
	# Game Data
	if FileAccess.file_exists(SAVE_PATH):
		load_data()
	else: reset_data()
	# Config Data
	

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
