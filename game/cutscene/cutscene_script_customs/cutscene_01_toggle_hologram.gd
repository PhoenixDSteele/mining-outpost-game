extends CutsceneFunc

@export var hub_area_holo : Node3D = null
@export var hologram_audio : AudioStreamPlayer = null

func effect():
	await get_tree().create_timer(0.5).timeout
	hologram_audio.play()
	hub_area_holo.visible = true
