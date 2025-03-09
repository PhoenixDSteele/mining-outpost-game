class_name SceneInfo extends Node

@export var actor_positions : Array[Vector3]
@export var actor_animations : Array[String]
@export var cam_move : bool = false
@export var cam_wobble : bool = false
@export var cam_move_time : float = 1.0
@export var cam_pos : Vector3
@export var cam_rot : Vector3
@export var portait : CharPortraits
@export var diag_audio : AudioStream

@export var speaker : String
@export_multiline var dialogue : String
@export var emotion : int

func set_scene(scene_actors:Array[CutsceneBody]):
	var increment : int = 0
	for actor in scene_actors:
		if actor.global_position != actor_positions[increment]:
			actor.global_position = actor_positions[increment]
		if actor.anim.current_animation != actor_animations[increment]:
			actor.anim.play(actor_animations[increment])
		increment += 1
	
	return [cam_pos, cam_rot, portait.portraits[emotion], speaker, dialogue, diag_audio, cam_move, cam_move_time, cam_wobble]
