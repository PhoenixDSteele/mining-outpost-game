class_name SceneInfo extends Node

@export var actor_positions : Array[Vector3]
@export var actor_animations : Array[String]
@export var cam_wobble : bool = false
@export var cam_move_time : float = 0.0
@export var look_at_target : Node3D = null
@export var portait : CharPortraits
@export var diag_audio : AudioStream

@export var speaker : String
@export_multiline var dialogue : String
@export var emotion : int

@export var custom_func : Node = null


func set_scene(scene_actors:Array[CutsceneBody]):
	var increment : int = 0
	for actor in scene_actors:
		if actor.global_position != actor_positions[increment]:
			actor.global_position = actor_positions[increment]
		if actor.anim.current_animation != actor_animations[increment]:
			actor.play_anim(actor_animations[increment], 0.2)
		increment += 1
	
	return [portait.portraits[emotion], speaker, dialogue, diag_audio, cam_move_time, cam_wobble]
