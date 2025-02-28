class_name UIController extends Node
## All inputs that handle UI based input should be put here.

@export var player: BodyBase

@onready var player_menu: PlayerMenu = %PlayerMenu
@onready var player_camera: PlayerCamera = %PlayerCamera
@onready var player_controller: PlayerController = $"../PlayerController"
@onready var hud: HUD = %HUD
@onready var map_viewport_container: SubViewportContainer = %SubViewportContainer


## Canvas Node, to instantiate during the pause menu.
var pause_menu_instance : PauseScreen
const PAUSE_SCREEN = preload("res://core/ui/pause_menu/pause_screen.tscn")

var pause_disabled : bool = false
var menu_disabled : bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not pause_disabled:
		if !get_tree().paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			pause_game()
		else:
			pause_menu_instance.resume_game()
	if event.is_action_pressed("inventory") and not menu_disabled:
		if (player_menu.visible == false):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			open_menu()
		elif (player_menu.visible == true):
			close_menu()

## Call pause menu. The rest will be handled by the pause menu node itself.
func pause_game():
	pause_menu_instance = PAUSE_SCREEN.instantiate()
	add_child(pause_menu_instance)

func open_menu():
	player.disabled = true
	player_camera.enter_menu()
	player_menu.setup_map_cam(player)
	player_menu.visible = true
	hud.visible = false
	player_controller.input_disabled = true

func close_menu():
	player_menu.return_map_cam().reparent(map_viewport_container)
	player.disabled = false
	player_camera.exit_menu()
	player_menu.visible = false
	hud.visible = true
	player_controller.input_disabled = false
