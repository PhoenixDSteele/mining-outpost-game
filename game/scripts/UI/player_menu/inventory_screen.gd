class_name InformationScreen extends Control
## 3D User Interface for player.
## Each button is hooked up to the same function, and sends a string that matches the nodes name to open the correct menu,
## and closes the non-matching names.

@onready var menus: Control = $Screen/MarginContainer/VBoxContainer/Menus
@onready var arm: Control = $Screen/MarginContainer/VBoxContainer/Menus/ARM
@onready var map: MapMenu = $Screen/MarginContainer/VBoxContainer/Menus/MAP
@onready var inventory: InventoryMenu = $Screen/MarginContainer/VBoxContainer/Menus/INVENTORY
@onready var data: Control = $Screen/MarginContainer/VBoxContainer/Menus/DATA

var current_menu : String = "map"

func open_menu(menu_name:String) -> void:
	if (current_menu != menu_name):
		current_menu = menu_name
		check_game_instance()
		for menu in menus.get_children():
			if menu.name.to_lower() == menu_name.to_lower():
				menu.visible = true
			else:
				menu.visible = false

func check_game_instance() -> void:
	match current_menu:
		"arm":
			pass
		"map":
			pass
		"inventory":
			inventory.calculate_battery_total()
		"data":
			pass
