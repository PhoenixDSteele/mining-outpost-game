class_name LedgeClimbState extends State
## Movement state for character.
##

## Uses to line model up with ledge depending on the model.

@export var turn_speed : float = 5.0

var target_slump : float = 0
var target_angle_pos : Vector3 = Vector3.ZERO
var target_rot_dir : Vector2 = Vector2.ZERO
var slide_pos : Vector3 = Vector3.ZERO

func enter() -> void:
	var ball_marker : MeshInstance3D = MeshInstance3D.new()
	add_child(ball_marker)
	ball_marker.mesh = SphereMesh.new()
	ball_marker.mesh.radius = 0.05
	ball_marker.mesh.height = 0.1
	ball_marker.global_position = climb_checker.wall_checker.get_collision_point()
	target_angle_pos = climb_checker.wall_checker.get_collision_point()
	target_slump = body.visual.position.y - (climb_checker.climb_pos.position.y - climb_checker.wall_checker.position.y)
	var bodyPos : Vector2 = Vector2(body.visual.global_position.x, body.visual.global_position.z)
	var edgePos : Vector2 = Vector2(target_angle_pos.x, target_angle_pos.z)
	target_rot_dir = (edgePos - bodyPos)
	body.gravity_enabled = false
	body.velocity = Vector3.ZERO
	
	slide_pos =  target_angle_pos - body.global_position
	
	body.anim_player.play("", 0.2)
	super.enter()


@warning_ignore("unused_parameter")
func handle_input(input) -> void:
	if active == true:
		if (input is String):
			if input == "climb":
				body.visual.position = Vector3.ZERO
				body.global_position = climb_checker.climb_pos.global_position
				Transition.emit(self, "idleState")


func update_process(_delta) -> void:
	body.visual.rotation.y = lerp_angle(body.visual.rotation.y, atan2(target_rot_dir.x, target_rot_dir.y), 5 * _delta)
	body.visual.position.y = lerp(body.visual.position.y, target_slump, 15 * _delta)
	body.visual.position.x = lerp(body.visual.position.x, slide_pos.x, 5 * _delta)
	body.visual.position.z = lerp(body.visual.position.z, slide_pos.z, 5 * _delta)


func update_physics(_delta) -> void:
	body.velocity = Vector3.ZERO


func exit() -> void:
	body.gravity_enabled = true
	climb_checker.can_climb = false
	super.exit()
