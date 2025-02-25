class_name ComputerScreen extends Interactable

var powered : Powered
var powered_on : bool = false

@onready var screen: KeyPadScreen = $KeyPadScreen
@onready var screen_camera: ScreenName = $ScreenCamera
var player_camera : Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in self.get_children():
		if node is Powered:
			powered = node
			powered.powered_state.connect(toggle_power)
	

func toggle_power(power_state:bool) -> void:
	powered_on = power_state
	if not powered_on:
		prompt_message = "NO POWER"
	elif powered_on:
		prompt_message = "USE KEYPAD"

func _on_interacted() -> void:
	if not powered_on:
		return
	elif powered_on:
		swap_cameras()

func swap_cameras():
	player_camera = get_viewport().get_camera_3d()
	screen_camera.camera.make_current()
