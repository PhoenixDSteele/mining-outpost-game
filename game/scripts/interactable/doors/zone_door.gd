class_name ZoneDoor extends Interactable

## Doors ID. Must be set to be referenced by another door going to it from another level.
@export_range(0, 1000, 1) var door_id : int = 0
## Doors target ID. Must be set to go to the correct door at other scene.
@export_range(0, 1000, 1) var target_door_id : int = 0
## Must set target level.
@export var target_level : String = ""

@export var music_to_play : String = ""
@export var open_sound : AudioStream
@export var close_sound : AudioStream
@export var locked_sound : AudioStream

## Used to lock/unlock the door as needed.
@export var locked : bool = false

@onready var spawn_point: Node3D = $SpawnPoint

## Animation player. Set animations to be called, "open_door", and "close_door".
@onready var animation_player: AnimationPlayer = $AnimationPlayer

## Reference to the audio. All the doors sounds played through this 3D Audio node.
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

## Reference to Label 3D, for setting the hovering name.
@onready var door_name: Label3D = $DoorName

func _ready() -> void:
	door_name.text = ("TO: <" + target_level + " | " + "Target ID: " + str(target_door_id) + ">" +
						"\n FROM: <" + str(get_parent().get_parent().name) + " | " + "ID: " + str(door_id) + ">" )

@warning_ignore("unused_parameter")
func _on_interacted(body: Variant) -> void:
	if target_level != "":
		if not locked:
			animation_player.play("open_door")
			audio.stream = open_sound
			audio.play()
			await get_tree().create_timer(1.0).timeout
			SceneManager.scene_change(target_level, target_door_id)
		else:
			audio.stream = locked_sound
			audio.play()
	else:
		print("No target level set.")
		audio.stream = locked_sound
		audio.play()
