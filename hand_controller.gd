extends Node3D

@export var move_speed : float = 3.0
@export var turn_speed : float = 1.0
@export var ground_offset : float = 0.552

@onready var pinky_ik_target: Marker3D = %PinkyIKTarget
@onready var ring_ik_target: Marker3D = %RingIKTarget
@onready var middle_ik_target: Marker3D = %MiddleIKTarget
@onready var index_ik_target: Marker3D = %IndexIKTarget
@onready var thumb_ik_target: Marker3D = %ThumbIKTarget

@onready var step_sound: AudioStreamPlayer3D = $StepSound
@onready var timer: Timer = $StepSound/Timer

var moving : bool = false

func _process(delta: float) -> void:
	var plane1 = Plane(thumb_ik_target.global_position, pinky_ik_target.global_position, index_ik_target.global_position)
	var plane2 = Plane(pinky_ik_target.global_position, index_ik_target.global_position, thumb_ik_target.global_position)
	var avg_normal = ((plane1.normal + plane2.normal) / 2).normalized()
	
	var target_basis = basis_from_normals(avg_normal)
	transform.basis = lerp(transform.basis, target_basis, move_speed * delta).orthonormalized()
	
	var avg = (pinky_ik_target.position + ring_ik_target.position + middle_ik_target.position + index_ik_target.position + thumb_ik_target.position) / 5
	var target_pos = avg + transform.basis.y * ground_offset
	var distance = transform.basis.y.dot(target_pos - position)
	position = lerp(position, position + transform.basis.y * distance, move_speed * delta)
	
	if Input.is_action_pressed("movement"):
		moving = true
		handle_movement(delta)
	else:
		moving = false


func handle_movement(delta) -> void:
	var dir  = Input.get_axis("move_forward", "move_backward")
	translate(Vector3(0, 0, -dir) * move_speed * delta)
	
	var a_dir = Input.get_axis("move_right", "move_left")
	rotate_object_local(Vector3.UP, a_dir * turn_speed * delta)

func basis_from_normals(normal:Vector3) -> Basis:
	var result = Basis()
	result.x = normal.cross(transform.basis.z)
	result.y = normal
	result.z = transform.basis.x.cross(normal)
	
	result = result.orthonormalized()
	result.x *= scale.x
	result.y *= scale.y
	result.z *= scale.z
	
	return result


func _on_timer_timeout() -> void:
	if moving:
		timer.wait_time = randf_range(0.18, 0.22)
		step_sound.pitch_scale = randf_range(0.95, 1.15)
		step_sound.play()
