class_name IdleState extends State
## Idle state for character.
##

func enter() -> void:
	super.enter()


@warning_ignore("unused_parameter")
func handle_input(input : Vector3) -> void:
	if input != Vector3.ZERO:
		Transition.emit(self, "movementstate")
		return


func on_camera_update(camera_rotation : float) -> void:
	pass


func update_process(_delta) -> void:
	pass


func update_physics(_delta) -> void:
	if body.is_on_floor() == false:
		Transition.emit(self, "fallstate")


func exit() -> void:
	super.exit()
