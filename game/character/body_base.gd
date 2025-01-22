class_name BodyBase extends CharacterBody3D
## Base class for all characters in the game.
##

## Node that is rotated/moved during state control. Attach the rig/mesh to this node.
@onready var visual: Node3D = %Visual

## Animtion player is searched for under the visual node, within it's child. Will return error if it can't find it.
## Can be manually set, and it won't attempt to search for it.
@export var anim_player : AnimationPlayer = null

## Collision is searched for under the root node. Will return error if it can't find it.
## Can be manually set, and it won't attempt to search for it.
@export var collision : CollisionShape3D = null

## Set if controlled by player; to send input to the statemachine.
@export var player_controller : PlayerController = null

## Set if controlled by player; to send ledge climbing information to statemachine.
@export var climb_checker : ClimbChecker = null

## Body Stats - Currently only Health, and Oxygen.
@export var stats : Stats = null

## Whether or not the character can breath.
var can_breath : bool = true

## Personal Body Gravity
@export var gravity : float = 8
var gravity_enabled : bool = true


func _ready() -> void:
	#if anim_player == null:
		#anim_player = find_anim_player()
	if collision == null:
		collision = find_collision()

func _physics_process(delta: float) -> void:
	# Add the gravity if it's enabled.
	if not is_on_floor() and (gravity_enabled == true):
		velocity.y -= gravity * delta
	
	# Reduces oxygen levels if cant breath.
	if (can_breath == false):
		stats.oxygen -= 1 * delta
	
	# Always active to make velocity movements possible in state machine.
	move_and_slide()

## Attempts to search for animation player if it's not manually set.
func find_anim_player() -> AnimationPlayer:
	for x in visual.get_child(0).get_children():
		if x is AnimationPlayer:
			return x
	OS.alert("No animation player found on curret body: " + str(self.name))
	get_tree().quit()
	return

## Attempts to search for collision if it's not manually set.
func find_collision() -> CollisionShape3D:
	for x in self.get_children():
		if x is CollisionShape3D:
			return x
	OS.alert("No collision found on curret body: " + str(self.name))
	get_tree().quit()
	return
