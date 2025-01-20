class_name IdleState extends State
## Idle state for character.
##

func enter() -> void:
	body.anim_player.play("idle", 0.2)
	super.enter()


@warning_ignore("unused_parameter")
func handle_input(input) -> void:
	if active == true:
		if input is Vector3:
			Transition.emit(self, "movementstate")
			return
		if (input is bool) and (body.is_on_floor()):
			if input == true:
				Transition.emit(self, "jumpstate")


func update_process(_delta) -> void:
	pass


func update_physics(_delta) -> void:
	if body.is_on_floor() == false:
		Transition.emit(self, "fallstate")
	
	body.velocity.x = 0.0
	body.velocity.z = 0.0


func exit() -> void:
	super.exit()
