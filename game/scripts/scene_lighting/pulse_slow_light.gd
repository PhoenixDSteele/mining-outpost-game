extends OmniLight3D

@export var low_val: float = 3.0
@export var high_val: float = 4.0
@export var pulse_speed: float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pulse_high()

func pulse_high():
	var t = get_tree().create_tween()
	t.tween_property(self, "omni_range", high_val, pulse_speed)
	t.tween_callback(pulse_low)

func pulse_low():
	var t = get_tree().create_tween()
	t.tween_property(self, "omni_range", low_val, pulse_speed)
	t.tween_callback(pulse_high)
