extends Marker3D

@export var step_target : Node3D = null
@export var step_disance : float = 0.5

var is_stepping : bool = false

func _process(delta: float) -> void:
	if abs(global_position.distance_to(step_target.global_position)) > step_disance:
		step()

func step() -> void:
	var target_pos = step_target.global_position
	#var half_way = (global_position + step_target.global_position) / 2
	is_stepping = true
	
	var tween = get_tree().create_tween()
	#tween.tween_property(self, "global_position", half_way + owner.basis.y, 0.1)
	tween.tween_property(self, "global_position", target_pos, 0.1)
	tween.tween_callback(func(): is_stepping = false)
