class_name CutsceneBody extends Node3D

@export var actor : String = ""
@export var default_animation : String = ""

@onready var anim: AnimationPlayer = $greygoober_combined/AnimationPlayer

func _ready() -> void:
	anim.play(default_animation)
