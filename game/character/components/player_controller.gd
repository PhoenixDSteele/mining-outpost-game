class_name PlayerController extends Node
## Player Controller, instantiated on a player controlled body by state machine.
##
## Don't manually place this. Put all player movement controls here.
##

## Used to output player input. [StateMachine] will connect [State]'s to this signal if they need player control.
signal input


##Disables Input
var input_disabled : bool = false

func _physics_process(_delta: float) -> void:
	if not input_disabled:
		if Input.is_action_pressed("movement"):
			input.emit(Vector3(Input.get_vector("move_left","move_right","move_forward","move_backward").x,
											0,
						Input.get_vector("move_left","move_right","move_forward","move_backward").y))
		if Input.is_action_just_released("movement"):
			input.emit(Vector3(Input.get_vector("move_left","move_right","move_forward","move_backward").x,
											0,
						Input.get_vector("move_left","move_right","move_forward","move_backward").y))
						
		if Input.is_action_just_pressed("jump"):
			input.emit(true)
			
		if Input.is_action_pressed("jump"):
			input.emit("climb")
			
		if Input.is_action_pressed("sprint"):
			input.emit("sprinting")
		if Input.is_action_just_released("sprint"):
			input.emit("not_sprinting")
		
		if Input.is_action_just_pressed("grapple"):
			input.emit("grapple_toggle")
		if Input.is_action_pressed("reel_in_grapple"):
			input.emit("grapple_reel")
		if Input.is_action_just_released("reel_in_grapple"):
			input.emit("grapple_reel_stop")

		if Input.is_action_pressed("spider_toggle"):
			input.emit("spider_toggle")
