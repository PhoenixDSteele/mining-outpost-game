extends CharacterBody3D

@export var move_speed = 5.0
@export var jump_height = 5.0
@export var turn_speed = 5.0

@onready var wall_change_detection: RayCast3D = %WallChangeDetection

@onready var player_camera: PlayerCamera = $PlayerCamera
@onready var hand: Node3D = $hand
@onready var anim: AnimationPlayer = $hand/AnimationPlayer
@onready var step_sound: AudioStreamPlayer3D = $StepSound
@onready var timer: Timer = $StepSound/Timer
@onready var land: AudioStreamPlayer3D = $Land
@onready var jump: AudioStreamPlayer3D = $Jump

var surface_moving : bool = false
var clinging : bool = false
var falling : bool = false
var transitioning : bool = false
var can_land : bool = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not transitioning:
		if wall_change_detection.is_colliding():
			align_to_new_normal(wall_change_detection.get_collision_normal(), wall_change_detection.get_collision_point())
			land.play()
	
	if event.is_action_pressed("jump") and not transitioning:
		anim.play("fall", 0.1)
		jump.play()
		
		velocity.y = 3
		can_land = false
		if clinging:
			detach_from_surface()


func _physics_process(delta: float) -> void:
	if !can_land:
		if is_on_floor() or is_on_wall() or is_on_ceiling():
			land.play()
			can_land = true
	
	if clinging or surface_moving:
		falling = false
	
	### Add the gravity.
	if not clinging:
		velocity.y += -5 * delta
		if not falling:
			if !is_on_floor() and !is_on_wall() and !is_on_ceiling():
				falling = true
				can_land = false
				detach_from_surface()
				anim.play("fall", 0.1)
	
	if Input.is_action_pressed("movement"):
		if (abs(velocity.y) > abs(0.1)) or (!is_on_floor() and !is_on_wall() and !is_on_ceiling()):
			anim.play("fall", 0.2)
			surface_moving = false
		else:
			surface_moving = true
			anim.play("walk", 0.2)
		var dir = Input.get_vector("move_backward", "move_forward", "move_right", "move_left").normalized()
		dir = dir.rotated(player_camera.yaw_node.rotation.y)
		var target_rotation = atan2(dir.y, dir.x)
		hand.rotation.y = lerp_angle(hand.rotation.y, target_rotation, turn_speed * delta)
		translate(Vector3(-dir.y, 0, -dir.x) * move_speed * delta)
	else:
		surface_moving = false
		if is_on_floor() or is_on_wall() or is_on_ceiling():
			anim.play("idle", 0.2)
			
		else:
			anim.play("fall", 0.2)
	
	move_and_slide()

func align_to_new_normal(new_normal:Vector3, attach_point:Vector3):
	velocity = Vector3.ZERO
	clinging = true
	transitioning = true
	var original = self.transform.basis.y
	var cosa = original.dot(new_normal)
	var alpha = acos(cosa)
	var axis = original.cross(new_normal)
	axis = axis.normalized()
	
	var t = get_tree().create_tween()
	
	t.tween_property(self, "transform", self.transform.rotated(axis, alpha), 0.1)
	t.parallel().tween_property(self, "global_position", wall_change_detection.get_collision_point(), 0.1)
	t.tween_callback(func(): transitioning = false)

func detach_from_surface() -> void:
	transitioning = true
	clinging = false
	var t = get_tree().create_tween()
	t.tween_property(self, "rotation", Vector3.ZERO, 0.2)
	t.tween_callback(func(): transitioning = false)

func _on_timer_timeout() -> void:
	if surface_moving:
		timer.wait_time = randf_range(0.18, 0.22)
		step_sound.pitch_scale = randf_range(0.95, 1.15)
		step_sound.play()
