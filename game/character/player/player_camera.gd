class_name PlayerCamera extends Node3D
## A camera controller used on objects we want to circle a camera around.
##
## This will be controlled by the player.
##

## Sends camera's current rotation.
signal camera_rotation(camera_rotation : float)

@export var player : BodyBase = null

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
@onready var interaction_ray: InteractionRay = %InteractionRay


var yaw : float = 0
var pitch : float = 0

## Changes camera settings when in menu.
var in_menu : bool = false

## In-Menu Clamp
var menu_clamp_yaw : float = 0
var menu_clamp_pitch : float = 0

## Transitioning For Camera Tweening
var transitioning : bool = false

func _ready() -> void:
	spring_arm.spring_length = camera_arm_length
	
	await get_tree().physics_frame

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if not in_menu:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			yaw += -event.relative.x * yaw_sensitivity
			pitch += -event.relative.y * pitch_sensitivity
		elif in_menu:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			yaw += -event.relative.x * yaw_sensitivity * 0.1
			pitch += -event.relative.y * pitch_sensitivity * 0.1

## Make menu visible, and moves camera to correct position.
func enter_menu():
	in_menu = true
	transitioning = true
	interaction_ray.toggle_crosshair_visibility(false)
	player.visual.rotation_degrees.y = 0
	yaw_node.rotation_degrees.y = 180
	pitch_node.rotation_degrees.x =  0
	yaw = 0
	pitch = 0
	menu_clamp_yaw = 0
	menu_clamp_pitch = 0
	transition_camera(Vector3(-0.8, 0, 0), 50)

## Resets Camera Back To Normal, and closes menu.
func exit_menu():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	in_menu = false
	interaction_ray.toggle_crosshair_visibility(true)
	transition_camera(Vector3.ZERO, 75)

func transition_camera(target_pos:Vector3, target_fov:float):
	var tween = create_tween().set_parallel(true)
	tween.tween_property(spring_arm, "position", target_pos, 0.2)
	tween.tween_property(camera,"fov",target_fov, 0.2)

func _physics_process(delta: float) -> void:
	# Camera Controls inside and out of menu.
	if not in_menu:
		pitch = clamp(pitch, pitch_min, pitch_max)
		yaw_node.rotation_degrees.y = lerpf(yaw_node.rotation_degrees.y, yaw, yaw_acceleration * delta)
		pitch_node.rotation_degrees.x = lerpf(pitch_node.rotation_degrees.x, pitch, pitch_acceleration * delta)
		camera_rotation.emit(yaw_node.rotation.y)
	elif in_menu:
		yaw = clamp(yaw, menu_clamp_yaw - 5, menu_clamp_yaw + 5)
		pitch = clamp(pitch, menu_clamp_pitch - 5, menu_clamp_pitch + 5)
		yaw_node.rotation_degrees.y = lerpf(yaw_node.rotation_degrees.y, yaw, yaw_acceleration * delta)
		pitch_node.rotation_degrees.x = lerpf(pitch_node.rotation_degrees.x, pitch, pitch_acceleration * delta)
