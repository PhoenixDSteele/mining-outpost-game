class_name StateMachine extends Node
## A State Machine that can be used by either an AI, or a Player.
##
## The state machine requires an initial state, such as [IdleState].
## The state machine will grab the parent node, which is a [BodyBase], and set it's [param body], which will be used in all the states.
##

## Node that is rotated/moved during state control. Attach the rig/mesh to this node.
@onready var visual: Node3D = %Visual

## Player Controller
var player_controller : PlayerController = null

## Camera
@onready var player_camera: PlayerCamera = %PlayerCamera

## Climber Checker - Used to check climbable conditions.
var climb_checker : ClimbChecker

## The controlled body.
var body : BodyBase = null


@export_category("States")
## Initial starting state. If not set, will return an error. Use [IdleState] for most characters.
@export var initial_state : State = null

## List of states, populated in [method _ready].
## [br][br]
## Key is lowercase name of the node, and the value is the [State] node itself.
var state_list : Dictionary = {}
## Currently running state.
var current_state : State = null

func _ready() -> void:
	self.body = get_parent()
	
	# Checks the set controller type at the main node, and propagates it to state machine.
	if body.player_controller != null:
		# Connects Player Controller.
		player_controller = body.player_controller
		# Connects ClimbChecker.
		climb_checker = body.climb_checker
		print("Player Controlled")
	if body.player_controller == null:
		print("AI Controlled")
	
	# Populates state list array with all children for calling.
	for child_state in self.get_children():
		if child_state is State:
			child_state.Transition.connect(state_transition)
			child_state.body = self.body
			if player_controller != null:
				child_state.player_controller = self.player_controller
				child_state.player_camera = player_camera 
				child_state.climb_checker = climb_checker
			state_list.get_or_add(child_state.name.to_lower(), child_state)
	
	# Failsafe error alert for making sure an initial state is set.
	if initial_state == null:
		OS.alert("No initial state set for: " + str(get_parent().name.to_upper()))
		get_tree().quit()
	else:
		state_transition(null, initial_state.name)

## Method called by the current [State]'s signal to exit [param state], and search the [param state_list] for the key using the provided [param next_state].
## [br][br]
## Example: [code] Transition.emit(self, "idlestate") [/code]
func state_transition(state:State, next_state:String) -> void:
	var state_to_enter : State =  state_list[next_state.to_lower()]
	
	if state_to_enter == state:
		return
	
	if current_state != null:
		current_state.exit()
	
	state_to_enter.enter()
	current_state = state_to_enter


func _process(delta: float) -> void:
		if current_state != null:
			current_state.update_process(delta)


func _physics_process(delta: float) -> void:
		if current_state != null:
			current_state.update_physics(delta)
