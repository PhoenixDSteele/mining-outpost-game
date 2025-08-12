extends CutsceneFunc

@export var hub_area_holo : Node3D = null
@export var warning_blip : MeshInstance3D = null
@export var lights : OmniLight3D = null
@export var warning_alarm: AudioStreamPlayer = null



func effect():
	warning_blip.visible = true
	blip_on()
	warning_alarm.play()
	AudioManager.stop_music()

func blip_off():
	var t = get_tree().create_tween()
	t.set_parallel(true)
	t.tween_property(warning_blip, "mesh:material:albedo_color:a", 0.0, 0.1)
	t.tween_property(lights, "light_color", Color(1.0, 0.572, 0.05), 0.1)
	await t.finished
	blip_on()

func blip_on():
	var t = get_tree().create_tween()
	t.set_parallel(true)
	t.tween_property(warning_blip, "mesh:material:albedo_color:a", 0.5, 0.1)
	t.tween_property(lights, "light_color", Color.RED, 0.1)
	
	await t.finished
	blip_off()
