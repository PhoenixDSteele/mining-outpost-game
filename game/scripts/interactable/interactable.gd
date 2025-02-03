class_name Interactable extends Node3D

signal interacted(body)

@export var prompt_message : String = "Object"
@export var interact_button = "interact"

func get_prompt():
	var input_action = ""
	for action in InputMap.action_get_events(interact_button):
		if action is InputEventKey:
			input_action = action.as_text_physical_keycode()
			break
	
	return prompt_message + "\n<" + input_action + ">"


func interact():
	interacted.emit()
