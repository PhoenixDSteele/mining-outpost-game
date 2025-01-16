class_name BodyBase extends CharacterBody3D
## Base class for all characters in the game.
##

## Node that is rotated/moved during state control. Attach the rig/mesh to this node.
@onready var visual: Node3D = %Visual

## Animtion player is searched for under the visual node, within it's child. Will return error if it can't find it.
## Can be manually set, and it won't attempt to search for it.
@export var anim_player : AnimationPlayer = null

## Controller type.
enum ControllerType {
	PLAYER,
	AI = -1}
@export var controller_Type : ControllerType = ControllerType.AI

func _ready() -> void:
	if anim_player == null:
		anim_player = find_anim_player()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func find_anim_player() -> AnimationPlayer:
	for x in visual.get_child(0).get_children():
		if x is AnimationPlayer:
			return x
	OS.alert("No animation player found on curret body: " + str(self.name))
	get_tree().quit()
	return
