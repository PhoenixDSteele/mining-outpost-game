class_name MovementState extends State
## Movement state for character.
##

@export var walk_speed : float = 2.0 ## Target max jog speed.
@export var jog_speed : float = 3.0 ## Target max sprint speed.
@export var acceleration : float = 3.0 ## Rate of acceleration
@export var decceleration : float = 3.0 ## Rate of decceleration.
@export var move_to_idle_velocity : float = 0.1 ## Point at which velocity is so low, it cuts velocity to zero, and transitions to idle.
@export var turn_speed : float = 6.0 ## Speed of characters body turning.

var move_speed : float = 0.0

## Movement Direction, as sent by the handled input.
var move_direction = Vector3.ZERO

var move_input : bool = false

func enter() -> void:
	move_speed = walk_speed
	super.enter()
	move_input = true


@warning_ignore("unused_parameter")
func handle_input(input) -> void:
	if active == true:
		if input is Vector3:
			move_direction = input.normalized()
			if move_direction != Vector3.ZERO:
				move_input = true
			else:
				move_input = false
		
		if (input is bool) and (body.is_on_floor()):
			if input == true:
				Transition.emit(self, "jumpstate")
				return
		
		if (input is String):
			if input == "sprinting":
				move_speed = jog_speed
			if input == "not_sprinting":
				move_speed = walk_speed
		
		if (input is String) and (body.is_on_floor()):
			if input == "spider_toggle":
				if body.spawn_allowed:
					body.velocity = Vector3.ZERO
					Transition.emit(self, "spiderhandstate")



func update_process(_delta) -> void:
	pass


func update_physics(_delta) -> void:
	if body.is_on_floor() == false:
		move_direction = Vector3.ZERO
		Transition.emit(self, "fallstate")
		return
	
	if move_input:
		if move_speed == jog_speed:
			body.anim_player.play("run", 3.0)
			pass
		elif move_speed == walk_speed:
			body.anim_player.play("walk" , 3.0)
			pass
		move_direction = move_direction.rotated(Vector3.UP, player_camera.yaw_node.rotation.y)
		var target_rotation = atan2(move_direction.x, move_direction.z) - body.rotation.y
		body.visual.rotation.y = lerp_angle(body.visual.rotation.y, target_rotation, turn_speed * _delta)
		body.velocity.x = lerp(body.velocity.x, move_direction.x * move_speed, acceleration * _delta)
		body.velocity.z = lerp(body.velocity.z, move_direction.z * move_speed, acceleration * _delta)
	else:
		body.anim_player.play("idle", 5.0)
		body.velocity.x = lerp(body.velocity.x, 0.0, decceleration * _delta)
		body.velocity.z = lerp(body.velocity.z, 0.0, decceleration * _delta)
		if absf(Vector2(body.velocity.x, body.velocity.z).length()) <= 0.1:
			body.velocity.x = 0.0
			body.velocity.z = 0.0
			move_direction = Vector3.ZERO
			Transition.emit(self, "idlestate")
			return

func exit() -> void:
	move_input = false
	super.exit()
