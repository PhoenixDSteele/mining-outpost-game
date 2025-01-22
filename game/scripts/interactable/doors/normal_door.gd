class_name NormalDoor extends Interactable

var light_source : Light3D
var powered : Powered

var powered_on : bool = false
@export var locked : bool = false
var opened : bool = false

@export var open_sound : AudioStream
@export var close_sound : AudioStream
@export var locked_sound : AudioStream

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer3D = %Audio

func _ready() -> void:
	for node in get_children():
		if node is Powered:
			powered = node
			powered.powered_state.connect(toggle_power)
		if node is Light3D:
			light_source = node

func toggle_power(power_state:bool) -> void:
	powered_on = power_state
	if not powered_on:
		light_source.light_color = Color.GOLD
		light_source.light_energy = 0.2
		prompt_message = "NO POWER"
	elif powered_on:
		if locked:
			light_source.light_color = Color.RED
			light_source.light_energy = 0.5
			prompt_message = "LOCKED"
		elif not locked:
			light_source.light_color = Color.GREEN_YELLOW
			light_source.light_energy = 0.5
			prompt_message = "Open Door"

@warning_ignore("unused_parameter")
func _on_interacted(body: Variant) -> void:
	if not powered_on:
		return
	elif powered_on:
		if not locked:
			if not opened:
				opened = true
				animation_player.play("open_door")
				audio.stream = open_sound
				audio.play()
			elif opened:
				opened = false
				animation_player.play("close_door")
				audio.stream = close_sound
				audio.play()
		elif locked:
			audio.stream = locked_sound
			audio.play()


func _on_close_range_body_exited(body: Node3D) -> void:
	if body is BodyBase:
		if opened:
			opened = false
			animation_player.play("close_door")
			audio.stream = close_sound
			audio.play()
