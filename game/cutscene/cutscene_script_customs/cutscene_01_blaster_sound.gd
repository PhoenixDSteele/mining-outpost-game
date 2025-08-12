extends CutsceneFunc

@export var blaster_explosion: AudioStreamPlayer = null

func effect():
	blaster_explosion.play()
