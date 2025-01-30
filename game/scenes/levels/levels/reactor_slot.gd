class_name ReactorSlot extends Interactable
## Will need to add one of these for reach area.


## Must match GameInstance level name.
@export var area : String = ""

## Power Source Inserted?
var active : bool = false

@onready var battery: MeshInstance3D = $Battery
@onready var power_off_light: OmniLight3D = $PowerOffLight

func _ready() -> void:
	setup_slot()
	if active:
		prompt_message = area.capitalize() + "\n POWER: ON"
	elif not active:
		prompt_message = area.capitalize() + "\n POWER: OFF"

## Checks GameInstance if the name is correct, then powers up if it exists.
func setup_slot() -> void:
	if GameInstance.powered_areas.has(area):
		if (GameInstance.powered_areas[area] == true):
			active = true
			power_off_light.visible = false
			battery.visible = true
		elif (GameInstance.powered_areas[area] == false):
			active = false
			power_off_light.visible = true
			battery.visible = false

@warning_ignore("unused_parameter")
func _on_interacted(body: Variant) -> void:
	if active:
		toggle_reactor_slot(false)
	elif not active:
		toggle_reactor_slot(true)

## Toggle slot if you have a battery.
func toggle_reactor_slot(inserting_battery:bool) -> void:
	if inserting_battery:
		if GameInstance.batteries > 0:
			GameInstance.toggle_area_power(area, true)
			GameInstance.batteries -= 1
			active = true
			power_off_light.visible = false
			battery.visible = true
			prompt_message = area.capitalize() + "\n POWER: ON"
	elif not inserting_battery:
		active = false
		GameInstance.toggle_area_power(area, false)
		GameInstance.batteries += 1
		power_off_light.visible = true
		battery.visible = false
		prompt_message = area.capitalize() + "\n POWER: OFF"
