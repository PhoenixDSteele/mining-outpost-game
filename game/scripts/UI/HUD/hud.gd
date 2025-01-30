class_name HUD extends Control

@onready var current_area : Label = $Panel/MarginContainer/VBoxContainer/HBoxContainer3/CurrentArea
@onready var area_power : Label = $Panel/MarginContainer/VBoxContainer/HBoxContainer/AreaPower
@onready var oxygen : ProgressBar = $Panel/MarginContainer/VBoxContainer/HBoxContainer2/ProgressBar

var current_level : Level

var can_breath : bool = true

var stats : Stats = null

func _ready() -> void:
	for node in get_parent().get_children():
		if node is Stats:
			stats = node
	
	
	if get_tree().current_scene is Level:
		current_level = get_tree().current_scene
	
	set_area_name()
	check_area_power()

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	oxygen.value = stats.oxygen
	if stats.oxygen <= 0:
		print("player died")


## Preset names for areas to clean them up for the HUD display.
func set_area_name():
	var area_name:String
	match current_level.level_name:
		"hub_area":
			area_name = "HUB"
		"checkpoint_north":
			area_name = "Checkpoint - North"
		"living_area":
			area_name = "Living Area"
		"security":
			area_name = "Security"
	
	current_area.text = "Current Area: " + area_name

func check_area_power():
	if GameInstance.powered_areas[current_level.level_name] == true:
		area_power.text = "Area Power: ON"
	else:
		area_power.text = "Area Power: OFF"
