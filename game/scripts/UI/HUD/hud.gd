class_name HUD extends Control

@onready var hud_dialogue: Control = $HUD_Dialogue

@onready var current_area: Label = %CurrentArea
@onready var fade: ColorRect = %Fade

@onready var hud_off: TextureRect = %HUD_off
@onready var hud_on: TextureRect = %HUD_on

@onready var oxygen_bar: ShaderMaterial = %OxygenBar.material
@onready var vignette: ShaderMaterial = $Vignette.material

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
	oxygen_bar.set("shader_parameter/progress", stats.oxygen / 100)
	oxygen_bar.set("shader_parameter/particle_speed", (stats.oxygen / 100) / 2)
	if stats.oxygen != 100:
		vignette.set("shader_parameter/vignette_strength", (100 - stats.oxygen) / 100)
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
		"mine_a_floor_1":
			area_name = "Mine A - Floor 1"
			
	current_area.text = area_name

func check_area_power():
	if GameInstance.powered_areas[current_level.level_name] == true:
		hud_on.visible = true
		hud_off.visible = false
	else:
		hud_off.visible = true
		hud_on.visible = false

func fade_out():
	var t = get_tree().create_tween()
	t.tween_property(fade,"color", Color(0,0,0,1.0), 0.5)

func fade_in():
	var t = get_tree().create_tween()
	t.tween_property(fade,"color", Color(0,0,0,0), 1.0)
