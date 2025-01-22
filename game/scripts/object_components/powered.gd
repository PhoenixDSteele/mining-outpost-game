class_name Powered extends Node
## Compoent required by powered objects like consoles, machines, etc.
## Function will be called by levels power setup, or left open ended to be powered by another source potentially.
##
signal powered_state(powered_on)

var powered_on : bool = false

## Turn the power on/off.
func toggle_power(powered:bool):
	if (powered == true):
		powered_on = true
		powered_state.emit(powered_on)
	elif (powered == false):
		powered_on = false
		powered_state.emit(powered_on)
