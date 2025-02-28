extends MeshInstance3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	rotation_degrees.y += 1
	if rotation_degrees.y == 360:
		rotation_degrees.y = 0
