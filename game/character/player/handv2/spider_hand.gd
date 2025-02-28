class_name SpiderHand extends CharacterBody3D

@export var move_speed = 5.0
@export var jump_height = 5.0
@export var turn_speed = 5.0
@export var attach_cooldown : float = 1.0
@export var dettach_cooldown : float = 2.0

@onready var wall_change_detection: RayCast3D = %WallChangeDetection

@onready var effect_node: ColorRect = %MenuEffect
@onready var menu_effect: ShaderMaterial = %MenuEffect.material
const SPIDER_HAND_FP_CAM = preload("res://assets/environments/cameras/spider_hand_fp_cam.tres")

@onready var player_camera: PlayerCamera = $PlayerCamera
@onready var hand: Node3D = $hand
@onready var anim: AnimationPlayer = $hand/AnimationPlayer
@onready var attach_cd: Timer = %AttachCD
@onready var dettach_cd: Timer = %DettachCD
@onready var ground_check_stairs: RayCast3D = $GroundCheckStairs
@onready var cling_release: Timer = $ClingRelease

#Sounds
@onready var step_sound: AudioStreamPlayer = %StepSound
@onready var timer: Timer = %Timer
@onready var land: AudioStreamPlayer = %Land
@onready var jump: AudioStreamPlayer = %Jump
@onready var zoom_in: AudioStreamPlayer = %ZoomIn
@onready var zoom_out: AudioStreamPlayer = %ZoomOut

#Bools
var surface_moving : bool = false
var clinging : bool = false
var falling : bool = false
var transitioning : bool = false
var can_land : bool = false
var can_attach : bool = true
var can_dettach : bool = true
var checking_cling_state : bool = false

var cam_zoom_on : bool = false

var disabled : bool = false

var state_ref : SpiderHandState

## Canvas Node, to instantiate during the pause menu.
var pause_menu_instance : PauseScreen
const PAUSE_SCREEN = preload("res://core/ui/pause_menu/pause_screen.tscn")




func _ready() -> void:
	player_camera.camera.make_current()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if !get_tree().paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			pause_game()
		else:
			pause_menu_instance.resume_game()
	
	if not disabled:
		if event.is_action_pressed("spider_zoom"):
				zoom_cam_toggle()

## Call pause menu. The rest will be handled by the pause menu node itself.
func pause_game():
	pause_menu_instance = PAUSE_SCREEN.instantiate()
	add_child(pause_menu_instance)

func zoom_cam_toggle():
	if cam_zoom_on == false:
		zoom_in.play()
		player_camera.camera.set_cull_mask_value(11, true)
		player_camera.camera.environment = SPIDER_HAND_FP_CAM
		effect_node.visible = true
		menu_effect.set("shader_parameter/warp_amount", 5)
		menu_effect.set("shader_parameter/clip_warp", false)
		player_camera.camera.fov = 50
		player_camera.pitch_max = 90
		player_camera.pitch_min = -90
		player_camera.spring_arm.spring_length = 0
		hand.visible = false
		cam_zoom_on = true
	else:
		zoom_out.play()
		player_camera.camera.set_cull_mask_value(11, false)
		player_camera.camera.environment = null
		effect_node.visible = false
		menu_effect.set("shader_parameter/warp_amount", 0)
		menu_effect.set("shader_parameter/clip_warp", true)
		player_camera.camera.fov = 75
		player_camera.pitch_max = 17
		player_camera.pitch_min = -70
		player_camera.spring_arm.spring_length = 1.2
		hand.visible = true
		cam_zoom_on = false

func _physics_process(delta: float) -> void:
	if not disabled:
		if not checking_cling_state:
			if not transitioning and get_slide_collision_count() == 0:
				checking_cling_state = true
				cling_release.start()
			
		if not clinging:
			velocity.y += -5 * delta
		
		if !can_land:
			if is_on_floor() or is_on_wall() or is_on_ceiling():
				land.play()
				can_land = true
		
		if wall_change_detection.is_colliding() and Input.is_action_pressed("movement") and !transitioning and !is_on_floor():
			align_to_new_normal(wall_change_detection.get_collision_normal(), wall_change_detection.get_collision_point())
		if Input.is_action_pressed("movement"):
			if not transitioning and get_slide_collision_count() == 0 and !ground_check_stairs.is_colliding():
				rotation = lerp(rotation, Vector3.ZERO, 3 * delta)
				surface_moving = false
				anim.play("fall", 0.2)
			else:
				surface_moving = true
				anim.play("walk", 0.2)
			var dir = Input.get_vector("move_backward", "move_forward", "move_right", "move_left").normalized()
			dir = dir.rotated(player_camera.yaw_node.rotation.y)
			var target_rotation = atan2(dir.y, dir.x)
			hand.rotation.y = lerp_angle(hand.rotation.y, target_rotation, turn_speed * delta)
			translate(Vector3(-dir.y, 0, -dir.x) * move_speed * delta)
			if is_on_floor() and !clinging:
				rotation = lerp(rotation, Vector3.ZERO, 10 * delta)
		else:
			surface_moving = false
			if is_on_floor() or is_on_wall() or is_on_ceiling():
				anim.play("idle", 0.2)
				if is_on_floor():
					rotation = lerp(rotation, Vector3.ZERO, 5 * delta)
			else:
				anim.play("fall", 0.2)
		
		if Input.is_action_just_pressed("jump") and not transitioning:
			if get_slide_collision_count() != 0 and is_on_floor_only():
				velocity.y = 3
				can_land = false
				anim.play("fall", 0.1)
				jump.play()
		
		if Input.is_action_pressed("jump") and not transitioning:
			if wall_change_detection.is_colliding() and not clinging:
				align_to_new_normal(wall_change_detection.get_collision_normal(), wall_change_detection.get_collision_point())
		
		if Input.is_action_just_pressed("detach_spider"):
			if clinging and can_dettach == true:
					detach_from_surface()
		
		move_and_slide()

@warning_ignore("unused_parameter")
func align_to_new_normal(new_normal:Vector3, attach_point:Vector3):
	if can_attach:
		can_dettach = false
		dettach_cd.start()
		land.play()
		can_attach = false
		attach_cd.start()
		velocity = Vector3.ZERO
		clinging = true
		transitioning = true
		var original = self.transform.basis.y
		var cosa = original.dot(new_normal)
		var alpha = acos(cosa)
		var axis = original.cross(new_normal)
		axis = axis.normalized()
		
		var t = get_tree().create_tween()
		
		t.tween_property(self, "transform", self.transform.rotated(axis, alpha), 0.25)
		t.parallel().tween_property(self, "global_position", wall_change_detection.get_collision_point(), 0.25)
		t.tween_callback(func(): transitioning = false)

func detach_from_surface() -> void:
	print('detaching')
	transitioning = true
	var t = get_tree().create_tween()
	t.tween_property(self, "rotation", Vector3.ZERO, 0.5)
	t.tween_callback(func(): transitioning = false)
	t.tween_callback(func(): clinging = false)

func _on_timer_timeout() -> void:
	if surface_moving:
		timer.wait_time = randf_range(0.18, 0.22)
		step_sound.pitch_scale = randf_range(0.95, 1.15)
		step_sound.play()

func _on_attach_cd_timeout() -> void:
	can_attach = true

func _on_dettach_cd_timeout() -> void:
	can_dettach = true

func _on_cling_release_timeout() -> void:
	checking_cling_state = false
	if not transitioning and get_slide_collision_count() == 0:
		clinging = false
