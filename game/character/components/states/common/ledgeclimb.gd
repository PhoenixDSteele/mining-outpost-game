class_name LedgeClimbState extends State
## Movement state for character.
##

func enter() -> void:
	body.velocity = Vector3.ZERO
	super.enter()


@warning_ignore("unused_parameter")
func handle_input(input) -> void:
	if active == true:
		pass


func update_process(_delta) -> void:
	pass


func update_physics(_delta) -> void:
	pass


func exit() -> void:
	super.exit()
