class_name ScreenName extends Node3D

@export var yaw_sensitivity : float = 0.01
@export var yaw_acceleration : float = 1

@export var pitch_sensitivity : float = 0.01
@export var pitch_acceleration : float = 1
@export_range(0, 90) var pitch_max : float = 180
@export_range(-90, 0) var pitch_min : float = -180


@onready var yaw_node: Node3D = %CamYaw
@onready var pitch_node: Node3D = %CamPitch
@onready var camera: Camera3D = %Camera3D

var yaw : float = 0
var pitch : float = 0

## Changes camera settings when in menu.
var in_menu : bool = false

## In-Menu Clamp
var menu_clamp_yaw : float = 0
var menu_clamp_pitch : float = 0

## Transitioning For Camera Tweening
var transitioning : bool = false

func _input(event: InputEvent) -> void:
	if camera.current:
		if event is InputEventMouseMotion:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			yaw += event.relative.x * yaw_sensitivity
			pitch += event.relative.y * pitch_sensitivity

## Make menu visible, and moves camera to correct position.
func enter_menu():
	pass

## Resets Camera Back To Normal, and closes menu.
func exit_menu():
	pass

func _physics_process(delta: float) -> void:
	if camera.current:
		yaw = clamp(yaw, menu_clamp_yaw - 2, menu_clamp_yaw + 2)
		pitch = clamp(pitch, menu_clamp_pitch - 2, menu_clamp_pitch + 2)
		yaw_node.rotation_degrees.y = lerpf(yaw_node.rotation_degrees.y, yaw, yaw_acceleration * delta)
		pitch_node.rotation_degrees.x = lerpf(pitch_node.rotation_degrees.x, pitch, pitch_acceleration * delta)
