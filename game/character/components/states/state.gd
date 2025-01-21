class_name State extends Node
## Base parent state class.
##
## Don't use this. Create inherited scripts with appropriate functions.
##

signal Transition

## Player Controller if selected.
var player_controller : PlayerController = null

## Player Camera.
var player_camera : PlayerCamera = null
var cam_rot : float = 0

## Climber Checker - Used to check climbable conditions.
var climb_checker : ClimbChecker = null

## The controlled body.
var body : BodyBase = null

## Active Boolean.
var active : bool = false

## Handles everything that needs to happen upon entering the state.
func enter() -> void:
	active = true
	if player_controller != null:
		if player_controller.input.is_connected(handle_input) == false:
			print("connected controller")
			player_controller.input.connect(handle_input)
	print(str(body.name.to_upper()) + " has entered their " + str(name) + ".") #DELETE LATER

## If PLAYER controls this state machine, this will take in all input from the assigned [PlayerController].
@warning_ignore("unused_parameter")
func handle_input(input) -> void:
	pass

## Handles everything that needs to happen per update.
func update_process(_delta) -> void:
	pass

## Handles everything that needs to happen per physics update.
func update_physics(_delta) -> void:
	pass

## Handles everything that needs to happen upon exiting the state.
func exit() -> void:
	active = false
	#print(str(body.name.to_upper()) + " has exited their " + str(name) + ".") #DELETE LATER
