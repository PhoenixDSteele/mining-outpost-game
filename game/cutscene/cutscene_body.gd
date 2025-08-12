class_name CutsceneBody extends Node3D

@export var actor : String = ""
@export var default_animation : String = ""

@export var anim: AnimationPlayer = null

func _ready() -> void:
	play_anim(default_animation, 0.2)

func play_anim(anim_name:String, blend:float):
	await get_tree().create_timer(randf_range(0,0.2)).timeout
	anim.play(anim_name, blend)
