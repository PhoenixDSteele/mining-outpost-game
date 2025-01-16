class_name PlayerCamera extends Node3D
## A camera controller used on objects we want to circle a camera around.
##
## This will be controlled by the player.
##

## Sends camera's current rotation.
signal camera_rotation(camera_rotation : float)

@export var camera_arm_length : float = 5.0

@export var yaw_sensitivity : float = 0.1
@export var yaw_acceleration : float = 20

@export var pitch_sensitivity : float = 0.1
@export var pitch_acceleration : float = 20
@export_range(0, 90) var pitch_max : float = 180
@export_range(-90, 0) var pitch_min : float = -180

@onready var yaw_node: Node3D = %CameraYaw
@onready var pitch_node: Node3D = %CameraPitch
@onready var spring_arm: SpringArm3D = %SpringArm3D
@onready var camera: Camera3D = %Camera3D

var yaw : float = 0
var pitch : float = 0

func _ready() -> void:
	await get_tree().physics_frame

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		yaw += -event.relative.x * yaw_sensitivity
		pitch += -event.relative.y * pitch_sensitivity
		camera_rotation.emit(yaw_node.rotation.y)

func _physics_process(delta: float) -> void:
	pitch = clamp(pitch, pitch_min, pitch_max)
	yaw_node.rotation_degrees.y = lerpf(yaw_node.rotation_degrees.y, yaw, yaw_acceleration * delta)
	pitch_node.rotation_degrees.x = lerpf(pitch_node.rotation_degrees.y, pitch, pitch_acceleration * delta)
