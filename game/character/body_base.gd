class_name BodyBase extends CharacterBody3D
## Base class for all characters in the game.
##
@onready var visual: Node3D = %Visual

## Controller type.
enum ControllerType {
	PLAYER,
	AI = -1}
@export var controller_Type : ControllerType = ControllerType.AI

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
