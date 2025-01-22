class_name ManualPowerOption extends HBoxContainer
signal toggle_state

@onready var check_box: CheckBox = %CheckBox
@onready var label: Label = %Label

func _on_check_box_toggled(toggled_on: bool) -> void:
	toggle_state.emit(label.text, toggled_on)
	if toggled_on:
		check_box.text = "ON"
	else:
		check_box.text = "OFF"
