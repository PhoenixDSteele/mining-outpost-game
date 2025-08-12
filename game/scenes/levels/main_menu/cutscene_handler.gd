class_name CutsceneHandler extends Node

signal cutscene_finished

@export var cutscene_id : String = ""
@export var cutscene_delay : float = 1.0
@export var cutscene_camera: CutsceneCamera = null
@onready var cutscene_hud: cutscene_HUD = $CutsceneHUD

var actor_list : Array[CutsceneBody] = []
var scene_list : Array[SceneInfo] = []

var pos : Vector3 = Vector3.ZERO
var look_at_target : bool = false

var cam_wobble : bool = false
var wobble_strength : float = 1.2
var default_degree : float = 0.0

func _ready() -> void:
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
		## Scene Array: [portait.portraits[emotion], speaker, dialogue, diag_audio, cam_move_time, cam_wobble]
		var scene_info:Array = scene.set_scene(actor_list)
		## portrait:Texture2D, speaker_name: String, dialogue:String, diag_audio:AudioStream
		cutscene_hud.update_information(scene_info[0], scene_info[1], scene_info[2], scene_info[3])
		for node in scene.get_children():
			if node is Marker3D:
				pos = Vector3(scene.look_at_target.global_position.x, scene.look_at_target.global_position.y+1,scene.look_at_target.global_position.z)
				if look_at_target != null:
					if scene_info[4] == 0:
						cutscene_camera.position = node.global_position
						cutscene_camera.look_at(Vector3(pos.x, pos.y, pos.z))
					else:
						var t = get_tree().create_tween()
						t.tween_property(cutscene_camera,"global_position", node.global_position, scene_info[4]).set_trans(Tween.TRANS_LINEAR)
						look_at_target = true
						await t.finished
			if node is CutsceneFunc:
				node.effect()
		cam_wobble = scene_info[5]
		if cam_wobble == true:
			default_degree = cutscene_camera.rotation_degrees.z
			camera_wobble(scene_info[5])
		await cutscene_hud.push_cutscene
		look_at_target = false
	print("cutscene finished")
	cutscene_finished.emit()

func _process(_delta: float) -> void:
	if look_at_target:
		cutscene_camera.look_at(pos)

func camera_wobble(wobble_speed:float = 0.2):
	if cam_wobble == true:
		var t = get_tree().create_tween()
		t.tween_property(cutscene_camera, "rotation_degrees:z", default_degree + wobble_strength, wobble_speed)
		t.tween_callback(func(): wobble_strength *= -1)
		t.tween_callback(camera_wobble)
	else:
		pass
