class_name Level extends Node
## The node used for creating all scenes.
##
## Make a child of this node for all levels the player will visit.
##


## Name of the level.
@export var level_name : String = ""

## Level Music.
@export var level_music : String = ""

@export var no_spawn : bool = false

## Used to spawn player in manually. Use Case: Cutscenes, and DEBUG menu, load/save.
@onready var manual_spawn_location: Marker3D = $ManualSpawnLocation

## Reference to the door node, used for creating the Door Dictionary.
@onready var doors: Node = %Doors


## Door dictionary. KEY is the door ID, and VALUE is the door node itself.
## On ready, gets all the doors placed under door node. For easier reference.
var door_dictionary : Dictionary = {}

const PLAYER = preload("res://game/character/player/player.tscn")

func _ready() -> void:
	# Puts all the available doors into the levels door dictionary. With it's door id, as the key value.
	for door in doors.get_children():
		if door is ZoneDoor:
			if door_dictionary.has(door.door_id):
				# Makes sure duplicate door IDs are not placed.
				OS.alert("Duplicate door id found, please check: " + str(door_dictionary[door.door_id].name) + ", and " + str(door.name) + ".")
				get_tree().quit()
			else:
				door_dictionary.get_or_add(door.door_id, door)

## Function used when entering a level to spawn the player into the correct door position.
func spawn_at_door(door_id:int) -> void:
	var player_instance : BodyBase = PLAYER.instantiate()
	add_child(player_instance)
	if no_spawn == false:
		if door_dictionary.has(door_id):
			player_instance.global_position = door_dictionary[door_id].spawn_point.global_position
		else:
			player_instance.global_position = manual_spawn_location.global_position
			OS.alert("Entered " + level_name + ", but couldn't find door ID: " + str(door_id))

## Manual Spawn Location 
func spawn_player_manually() -> void:
	if no_spawn == false:
		var player_instance : BodyBase = PLAYER.instantiate()
		add_child(player_instance)
		player_instance.global_position = manual_spawn_location.global_position
