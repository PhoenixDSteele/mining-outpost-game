class_name FallState extends State
## Idle state for character.
##

@export var air_move_speed : float = 5.0 ## Target max movespeed.
@export var acceleration : float = 5.0 ## Rate of acceleration
@export var decceleration : float = 5.0 ## Rate of decceleration.

## Movement Direction, as sent by the handled input.
var move_direction = Vector3.ZERO

var move_input : bool = false
var cam_rot : float = 0

func enter() -> void:
	super.enter()
	move_input = true


@warning_ignore("unused_parameter")
func handle_input(input : Vector3) -> void:
	move_direction = input.rotated(Vector3.UP, cam_rot)
	if move_direction != Vector3.ZERO:
		move_input = true
	else:
		move_input = false


func on_camera_update(camera_rotation : float) -> void:
	pass


func update_process(_delta) -> void:
	if body.is_on_floor():
		Transition.emit(self, "idlestate")
	
	if move_input:
		body.velocity.x = lerpf(body.velocity.x, move_direction.x * air_move_speed, acceleration * _delta)
		body.velocity.z = lerpf(body.velocity.z, move_direction.z * air_move_speed, acceleration * _delta)
	else:
		body.velocity.x = lerpf(body.velocity.x, 0.0, decceleration * _delta)
		body.velocity.z = lerpf(body.velocity.z, 0.0, decceleration * _delta)


func update_physics(_delta) -> void:
	pass


func exit() -> void:
	super.exit()
