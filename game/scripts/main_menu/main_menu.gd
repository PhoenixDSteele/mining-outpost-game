class_name MainMenu extends CanvasLayer
## Main Menu scene
##

@onready var options_menu: Control = $OptionsMenu


@warning_ignore("standalone_expression") # Working correctly as intended. -Phoenix
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# Starts Menu Music.
	if AudioManager.current_song != "main_menu":
		AudioManager.play_music("main_menu")

## Connected to the start button. Goes to the selected scene.
func _start_button_pressed() -> void:
	SceneManager.scene_change(SceneManager.level_hub_area)

## Connected to the options button. Goes to the options screen.
func _options_button_pressed() -> void:
	get_tree().quit()

## Connected to the exit button. Ends the game.
func _exit_button_pressed() -> void:
	get_tree().quit()


func _on_options_button_pressed() -> void:
	options_menu.on_enter()


func _on_debug_area_button_pressed() -> void:
	SceneManager.scene_change(SceneManager.level_debug)
