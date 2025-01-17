class_name ClimbChecker extends Node3D


var can_climb : bool = false

@onready var wall_checker: RayCast3D = $WallChecker
@onready var no_wall_checker: RayCast3D = $NoWallChecker
@onready var climb_pos: Node3D = $ClimbPos

func _physics_process(delta: float) -> void:
	if wall_checker.is_colliding():
		if !no_wall_checker.is_colliding():
			can_climb = true
		else:
			can_climb = false
