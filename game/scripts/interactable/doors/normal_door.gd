class_name NormalDoor extends Interactable

var light_source : SingleDoorLight
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
	for node in self.get_children():
		if node is Powered:
			powered = node
			powered.powered_state.connect(toggle_power)
		if node is SingleDoorLight:
			light_source = node

func toggle_power(power_state:bool) -> void:
	powered_on = power_state
	if not powered_on:
		if light_source:
			light_source.powered_off()
		prompt_message = "NO POWER"
	elif powered_on:
		if locked:
			if light_source:
				light_source.powered_on_locked()
			prompt_message = "LOCKED"
		elif not locked:
			if light_source:
				light_source.powered_on_unlocked()
			prompt_message = "Open Door"

func toggle_lock(locked_status:bool) -> void:
	if locked_status:
		locked = true
		if light_source:
			light_source.powered_on_locked()
		prompt_message = "LOCKED"
	elif not locked_status:
		locked = false
		if light_source:
			light_source.powered_on_unlocked()
		prompt_message = "Open Door"

func _on_interacted() -> void:
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
