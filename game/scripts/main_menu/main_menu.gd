class_name MainMenu extends CanvasLayer
## Main Menu scene
##

@onready var options_menu: Control = $OptionsMenu

@export var intro_cutscene: CutsceneHandler = null

@onready var bg_flash: ColorRect = $BGFlash

@onready var control: Control = $Control
@onready var logo: TextureRect = $Logo

@warning_ignore("standalone_expression") # Working correctly as intended. -Phoenix
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	## Starts Menu Music.
	if AudioManager.current_song != AudLib.song.main_theme:
		AudioManager.play_music(AudLib.song.main_theme)

## Connected to the start button. Goes to the selected scene.
func _start_button_pressed() -> void:
	AudioManager.play_music(AudLib.song.mine_theme)
	AudioManager.play_UI_sound(AudLib.ui.stinger_01)
	control.visible = false
	start_game()

func start_game():
	bg_flash.visible = true
	await get_tree().create_timer(1.0).timeout
	var t = get_tree().create_tween()
	t.set_parallel(true)
	t.tween_property(bg_flash, "modulate:a", 0.0, 1.0)
	t.tween_property(logo, "modulate:a", 0.0, 1.0)
	
	await t.finished
	
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	intro_cutscene.start_cutscene()
	intro_cutscene.cutscene_finished.connect(go_to_hud)

func go_to_hud():
	SceneManager.scene_change(SceneManager.level_hub_area)

## Connected to the options button. Goes to the options screen.
func _options_button_pressed() -> void:
	get_tree().quit()

## Connected to the exit button. Ends the game.
func _exit_button_pressed() -> void:
	get_tree().quit()

func _on_options_button_pressed() -> void:
	options_menu.on_enter()
