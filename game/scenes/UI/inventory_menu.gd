class_name InventoryMenu extends Control

@onready var battery_picture: TextureRect = $MarginContainer/VBoxContainer/Panel/MarginContainer/VBoxContainer/BatteryPicture
@onready var battery_total: Label = %BatteryTotal

func calculate_battery_total() -> void:
	if GameInstance.batteries > 0:
		battery_total.text = "Total: " + str(GameInstance.batteries)
	else:
		battery_total.text = "Total: 0"
