class_name MainMenu extends CanvasLayer
## Main Menu scene
##

func _ready() -> void:
	# Starts Menu Music.
	if SceneManager.on_main_menu == false:
		AudioManager.play_music("main_menu")
		SceneManager.on_main_menu == true

## Connected to the start button. Goes to the selected scene.
func _start_button_pressed() -> void:
	SceneManager.to_gameplay()

## Connected to the start button. Ends the game.
func _exit_button_pressed() -> void:
	get_tree().quit()
