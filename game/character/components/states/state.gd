class_name State extends Node
## Base parent state class.
##
## Don't use this. Create inherited scripts with appropriate functions.
##

signal Transition

## Controller type.
enum ControllerType {
	PLAYER,
	AI = -1}

## Controller type.
var controller_Type : ControllerType

## Player Controller if selected.
var player_controller : PlayerController = null

## Player Camera.
var player_camera : PlayerCamera = null

## The controlled body.
var body : BodyBase = null

## Handles everything that needs to happen upon entering the state.
func enter() -> void:
	if player_controller != null:
		player_controller.input.connect(handle_input)
	if player_camera != null:
		player_camera.camera_rotation.connect(on_camera_update)
	print(str(body.name.to_upper()) + " has entered their " + str(name) + ".") #DELETE LATER

## If PLAYER controls this state machine, this will take in all input from the assigned [PlayerController].
@warning_ignore("unused_parameter")
func handle_input(input : Vector3) -> void:
	pass

func on_camera_update(camera_rotation : float) -> void:
	pass

## Handles everything that needs to happen per update.
func update_process(_delta) -> void:
	pass

## Handles everything that needs to happen per physics update.
func update_physics(_delta) -> void:
	pass

## Handles everything that needs to happen upon exiting the state.
func exit() -> void:
	if player_controller != null:
		player_controller.input.disconnect(handle_input)
	if player_camera != null:
		player_camera.camera_rotation.disconnect(on_camera_update)
	#print(str(body.name.to_upper()) + " has exited their " + str(name) + ".") #DELETE LATER
