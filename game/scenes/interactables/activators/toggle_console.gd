class_name ToggleConsole extends Interactable
signal console_used

@export var activated_object : Node3D

@onready var console: MeshInstance3D = $Console
var material : StandardMaterial3D

var powered : Powered
var powered_on : bool = false

func _ready() -> void:
	material = console.get_active_material(2)
	for node in self.get_children():
		if node is Powered:
			powered = node
			powered.powered_state.connect(toggle_power)
	
	if activated_object is NormalElevator:
		self.console_used.connect(activated_object.active_elevator)
	

func toggle_power(power_state:bool) -> void:
	powered_on = power_state
	if not powered_on:
		material.emission_enabled = false
		prompt_message = "NO POWER"
	elif powered_on:
		material.emission_enabled = true
		prompt_message = "ACTIVATE"

func _on_interacted() -> void:
	if not powered_on:
		return
	elif powered_on:
		console_used.emit()
		print('used')
