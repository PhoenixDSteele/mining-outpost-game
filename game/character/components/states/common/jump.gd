class_name JumpState extends State
## Idle state for character.
##

@export var jump_height : float = 5
@export var air_move_speed : float = 10.0 ## Target max movespeed.
@export var acceleration : float = 5.0 ## Rate of acceleration
@export var decceleration : float = 1.0 ## Rate of decceleration.
@export var turn_speed : float = 5.0 ## Speed of characters body turning.

## Movement Direction, as sent by the handled input.
var move_direction = Vector3.ZERO

var move_input : bool = false

func enter() -> void:
	body.anim_player.play("jump_up", 0.2)
	super.enter()
	body.velocity.y += jump_height

@warning_ignore("unused_parameter")
func handle_input(input) -> void:
	if active == true:
		if input is Vector3:
			move_direction = input.normalized()
			if move_direction != Vector3.ZERO:
				move_input = true
			else:
				move_input = false


func update_process(_delta) -> void:
	pass


func update_physics(_delta) -> void:
	if move_input:
		move_direction = move_direction.rotated(Vector3.UP, player_camera.yaw_node.rotation.y)
		var target_rotation = atan2(move_direction.x, move_direction.z) - body.rotation.y
		body.visual.rotation.y = lerp_angle(body.visual.rotation.y, target_rotation, turn_speed * _delta)
		body.velocity.x = lerpf(body.velocity.x, move_direction.x * air_move_speed, acceleration * _delta)
		body.velocity.z = lerpf(body.velocity.z, move_direction.z * air_move_speed, acceleration * _delta)
	else:
		body.velocity.x = lerpf(body.velocity.x, 0.0, decceleration * _delta)
		body.velocity.z = lerpf(body.velocity.z, 0.0, decceleration * _delta)
	
	if body.velocity.y <= 0:
		move_direction = Vector3.ZERO
		Transition.emit(self,"fallstate")

func exit() -> void:
	move_input = false
	super.exit()
