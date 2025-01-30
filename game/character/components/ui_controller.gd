class_name UIController extends Node

## Canvas Node, to instantiate during the pause menu.
var pause_menu_instance : PauseScreen
const PAUSE_SCREEN = preload("res://game/scenes/UI/pause_screen.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if SceneManager.current_scene != "main_menu":
			if !get_tree().paused:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				pause_game()
			else:
				pause_menu_instance.resume_game()

## Call pause menu. The rest will be handled by the pause menu node itself.
func pause_game():
	pause_menu_instance = PAUSE_SCREEN.instantiate()
	add_child(pause_menu_instance)
