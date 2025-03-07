class_name CutsceneHandler extends Node

signal cutscene_finished

@export var cutscene_delay : float = 1.0
@export var screen_camera: ScreenName = null
@onready var cutscene_hud: cutscene_HUD = $CutsceneHUD

var actor_list : Array[CutsceneBody] = []
var scene_list : Array[SceneInfo] = []

func _ready() -> void:
	print(screen_camera.transform)
	for node in self.get_children():
		if node is CutsceneBody:
			actor_list.append(node)
		if node is SceneInfo:
			scene_list.append(node)

func start_cutscene():
	cutscene_hud.cinematic_bars.visible = true
	cutscene_hud.fade_in_bars()
	await get_tree().create_timer(cutscene_delay).timeout
	cutscene_hud.diag_box.visible = true
	for scene in scene_list:
		## Scene Array: [0]cam_pos, [1]cam_rot, [2]portait, [3]name, [4]dialogue, [5]diag_audio, [6]moves? , [7]cam_move_time
		var scene_info:Array = scene.set_scene(actor_list)
		## portrait:Texture2D, speaker_name: String, dialogue:String, diag_audio:AudioStream
		cutscene_hud.update_information(scene_info[2], scene_info[3], scene_info[4], scene_info[5])
		if scene_info[5] == false:
			screen_camera.position = scene_info[0]
			screen_camera.rotation_degrees = scene_info[1]
		else:
			var t = get_tree().create_tween()
			t.set_parallel(true)
			t.tween_property(screen_camera,"position", scene_info[0], scene_info[6]).set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_SINE)
			t.tween_property(screen_camera,"rotation_degrees", scene_info[1], scene_info[6]).set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_SINE)
			await t.finished
		await cutscene_hud.push_cutscene
	print("cutscene finished")
	cutscene_finished.emit()
