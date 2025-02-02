extends Node


## Scene change duration.
@export var scene_change_duration: float = 3

## Timer used to determine the time given for loading out/in.
@onready var scene_change_timer: Timer = $SceneChangeTimer

## Simple Canvas Node To Cover Everything. Has functions, 'fade_in', and 'fade_out'.
var load_screen_instance : LoadingScreen
const LOADING_SCREEN = preload("res://core/scene_manager/loading_screen/loading_screen.tscn")

## Current Scene, and Next Scene to go to.
var current_scene : String
var next_scene : PackedScene
var loaded_level : Level

## Dictionary of scenes. Add more as needed. If you add a scene to the dictionary, add it as a const underneath as well for auto-complete.
var known_scenes: Dictionary = {
	"main_menu": preload("res://game/scenes/levels/main_menu/main_menu.tscn"),
	"debug": preload("res://game/scenes/levels/debug/debug.tscn"),
	"hub_area": preload("res://game/scenes/levels/levels/level_hub_area.tscn"),
	"checkpoint_north": preload("res://game/scenes/levels/levels/level_checkpoint_north.tscn"),
	"living_area": preload("res://game/scenes/levels/levels/level_living_area.tscn"),
	"security": preload("res://game/scenes/levels/levels/level_security.tscn")
}

const level_main_menu:String = "main_menu" ## Main Menu
const level_debug:String = "debug" ## Debug
const level_hub_area:String = "hub_area" ## Hub Area
const level_checkpoint_north:String = "checkpoint_north" ## Checkpoint North
const level_living_area:String = "living_area" ## Living Area
const level_security:String = "security" ## Security

## Main Menu Check Boolean; Used to prevent pausing on main menu.
var on_main_menu : bool = false
## Paused Check; Checks if game is paused.
var paused : bool = false

## Stored Scene Name For Load Functions.
var next_scene_name : String = ""
## Stored Door ID For Load Functions.
var next_door_id : int = 0

## Starts timer, and spawns a loading screen.
## Connects the loading screen signals, and handles the fade on the object itself.
func scene_change(scene_name:String, door_id:int = 1000) -> void:
	current_scene = scene_name
	if scene_change_timer.is_stopped():
		next_scene_name = scene_name
		next_door_id = door_id
		load_screen_instance = LOADING_SCREEN.instantiate()
		add_child(load_screen_instance)
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		load_screen_instance.fade_out_finished.connect(load_scene)
		load_screen_instance.fade_in_finished.connect(clear_load_screen)
		load_screen_instance.fade_out()
	else:
		return

## Load scene, and waits until next game loop to call the scene change being finished. If door id not included, defaults to a manual spawn.
func load_scene() -> void:
	next_scene = known_scenes[next_scene_name]
	
	get_tree().change_scene_to_packed(next_scene)
	
	await get_tree().physics_frame
	loaded_level = get_tree().current_scene
	
	if next_door_id == 1000:
		if  loaded_level.no_spawn != true:
			loaded_level.spawn_player_manually()
			print("No door ID detected, manually spawning at default location.")
	else:
		loaded_level.spawn_at_door(next_door_id)
	if loaded_level.level_music != "":
		if loaded_level.level_music != AudioManager.current_song:
			AudioManager.play_music(loaded_level.level_music)
		
	scene_change_finished()

## Uses built in signal for the timer node.
func scene_change_finished() -> void:
	load_screen_instance.fade_in()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	print(loaded_level)


## Clears load screen.
func clear_load_screen() -> void:
	load_screen_instance.queue_free()
