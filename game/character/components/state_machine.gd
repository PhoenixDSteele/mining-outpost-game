class_name StateMachine extends Node
## A State Machine that can be used by either an AI, or a Player.
##
## The state machine requires an initial state, such as [IdleState].
## The state machine will grab the parent node, which is a [BodyBase], and set it's [param body], which will be used in all the states.
##

## Controller type.
enum ControllerType {
	PLAYER,
	AI = -1}
var controller_Type : ControllerType = ControllerType.AI

## Player Controller
var player_controller : PlayerController = null

## Camera
var player_camera : Resource
var camera_instance : PlayerCamera

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
	if body.controller_Type == body.ControllerType.PLAYER:
		# Add Player Controller.
		player_controller = PlayerController.new()
		player_controller.name = "PlayerController"
		get_parent().add_child.call_deferred(player_controller)
		# Loads in Camera, and adds it.
		player_camera = load("res://game/character/player/player_camera.tscn")
		camera_instance = player_camera.instantiate()
		camera_instance.position.y = 0.5
		camera_instance.name = "PlayerCamera"
		get_parent().add_child.call_deferred(camera_instance)
		self.controller_Type = ControllerType.PLAYER
		print("Player Controlled")
	elif controller_Type == ControllerType.AI:
		self.controller_Type = ControllerType.AI
		print("AI Controlled")
	
	# Populates state list array with all children for calling.
	for child_state in self.get_children():
		if child_state is State:
			child_state.Transition.connect(state_transition)
			child_state.body = self.body
			child_state.controller_Type = self.controller_Type
			if player_controller != null:
				child_state.player_controller = self.player_controller
			if camera_instance != null:
				child_state.player_camera = self.camera_instance
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
