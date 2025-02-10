extends Marker3D

@export var step_target : Node3D = null
@export var step_disance : float = 0.5
@export var speed : float = 0.1

@export var adjacent_target : Node3D = null

var is_stepping : bool = false

func _process(delta: float) -> void:
	if adjacent_target != null:
		if !is_stepping && !adjacent_target.is_stepping && abs(global_position.distance_to(step_target.global_position)) > step_disance:
			step()
	else:
		abs(global_position.distance_to(step_target.global_position)) > step_disance
		step()

func step() -> void:
	var target_pos = step_target.global_position
	is_stepping = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", target_pos, speed)
	tween.tween_callback(func(): is_stepping = false)
