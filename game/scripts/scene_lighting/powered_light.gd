extends Node3D
## Add to scene, and attach a light to it. That light will be a powered node, and be affected by an area's power
##

@export_range(0.0, 1.0) var powered_on_energy : float = 1.0
@export_range(0.0, 0.5) var powered_off_energy : float = 0.0


var light_source : Light3D
var powered : Powered

func _ready() -> void:
	for node in get_children():
		if node is Powered:
			powered = node
			powered.powered_state.connect(toggle_power)
		if node is Light3D:
			light_source = node

func toggle_power(power_state:bool) -> void:
	if (power_state == true):
		light_source.light_energy = powered_on_energy
	elif (power_state == false):
		light_source.light_energy = powered_off_energy
