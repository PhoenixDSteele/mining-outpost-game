extends Node
## Used to store everything we need to save/load. Must be persistent. So it is in autoload.
##

## List of areas for electricity to be power up. Must correlate with the scene manager areas.
var powered_areas : Dictionary = {
	"main_menu": true,
	"debug": true,
	"hub_area": true,
	"checkpoint_north": false,
	"living_area": false,
	"security": false
}

## Searches dictionary for the area provided, and sets it's power state.
func toggle_area_power(area_name:String, powered_state:bool):
	if powered_areas.has(area_name):
		powered_areas[area_name] = powered_state
		if SceneManager.current_scene == area_name:
			print("yooooooooooooo")
			SceneManager.loaded_level.check_powered_objects()

## Key Items
var batteries : float = 0
