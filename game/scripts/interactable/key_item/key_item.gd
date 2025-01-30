class_name KeyItem extends Interactable
## I don't expect a lot of key items in the game for our project;
## So I think we'll be alright with internalizing the items within this script, and add more as needed.
##

## Current list of key items: "battery"
@export var item_name : String = "SET THIS TEXT"

func _ready() -> void:
	prompt_message = "Pick Up " + item_name.capitalize()

@warning_ignore("unused_parameter")
func _on_interacted(body: Variant) -> void:
	var free_item_up:bool = false
	match item_name:
		"battery":
			GameInstance.batteries += 1
			free_item_up = true
		"SET THIS TEXT":
			printerr("Interacted Key Item Name Not Set")
			OS.alert("Interacted Key Item Name Not Set")
		_:
			printerr("Incorrect Key Item Name Found: " + item_name)
			OS.alert("Incorrect Key Item Name Found: " + item_name)
	
	if (free_item_up == true):
		queue_free()
