class_name BodyBase extends CharacterBody3D
## Base class for all characters in the game.
##

## Node that is rotated/moved during state control. Attach the rig/mesh to this node.
@onready var visual: Node3D = %Visual

## Animtion player is searched for under the visual node, within it's child. Will return error if it can't find it.
## Can be manually set, and it won't attempt to search for it.
@export var anim_player : AnimationPlayer = null

## Collision is searched for under the root node. Will return error if it can't find it.
## Can be manually set, and it won't attempt to search for it.
@export var collision : CollisionShape3D = null

## Set if controlled by player; to send input to the statemachine.
@export var player_controller : PlayerController = null

## Set if controlled by player; to send input to the statemachine.
@export var ui_controller : UIController = null

## Set if controlled by player; to send ledge climbing information to statemachine.
@export var climb_checker : ClimbChecker = null

## Body Stats - Currently only Health, and Oxygen.
@export var stats : Stats = null

## HUD REF
@onready var hud: HUD = %HUD

## Spider Stuff
@onready var spider_spawn_position: Marker3D = %SpiderSpawnPosition
@onready var spider_spawn_check: Area3D = %SpiderSpawnCheck
var spawn_allowed : bool = true
var colliding_spider_array : Array = []
var spiderhand : SpiderHand = null

@onready var check_debug_spider: MeshInstance3D = $Visual/SpiderSpawnCheck/CheckDebugSpider


## Whether or not the character can breath.
var can_breath : bool = true

## Personal Body Gravity
@export var gravity : float = 9
var gravity_enabled : bool = true

@onready var player_camera: PlayerCamera = %PlayerCamera


func _ready() -> void:
	#if anim_player == null:
		#anim_player = find_anim_player()
	if collision == null:
		collision = find_collision()
	
	player_camera.camera.make_current()


func _physics_process(delta: float) -> void:
	
	player_camera.global_position = lerp(player_camera.global_position, Vector3(self.global_position.x, self.global_position.y + 1.5, self.global_position.z), 10 * delta)
	
	# Add the gravity if it's enabled.
	if not is_on_floor() and (gravity_enabled == true):
		velocity.y -= gravity * delta
	
	# Handles Oxygen Stat Levels
	if (can_breath == false) and (stats.oxygen != -1):
		stats.oxygen -= 1 * delta
	elif (can_breath == true) and (stats.oxygen != 100):
		stats.oxygen += 1 * delta
	
	# Always active to make velocity movements possible in state machine.
	move_and_slide()

## Attempts to search for animation player if it's not manually set.
func find_anim_player() -> AnimationPlayer:
	for x in visual.get_child(0).get_children():
		if x is AnimationPlayer:
			return x
	OS.alert("No animation player found on current body: " + str(self.name))
	printerr("No animation player found on current body: " + str(self.name))
	get_tree().quit()
	return

## Attempts to search for collision if it's not manually set.
func find_collision() -> CollisionShape3D:
	for x in self.get_children():
		if x is CollisionShape3D:
			return x
	OS.alert("No collision found on current body: " + str(self.name))
	printerr("No collision found on current body: " + str(self.name))
	get_tree().quit()
	return

func spider_hand_cancel():
	ui_controller.menu_disabled = false
	player_controller.input_disabled = false
	player_camera.interaction_ray.target_info.visible = true

func _on_spider_spawn_check_body_entered(body: Node3D) -> void:
	if (body is StaticBody3D) or (body is CSGShape3D):
		if body.get_collision_layer_value(1) == true:
			colliding_spider_array.append(body)
			spawn_allowed = false
			var mat : StandardMaterial3D = check_debug_spider.get_active_material(0)
			mat.albedo_color = Color(1,0,0,0.2)

func _on_spider_spawn_check_body_exited(body: Node3D) -> void:
	if body is StaticBody3D or (body is CSGShape3D):
		if body.get_collision_layer_value(1) == true:
			if colliding_spider_array.has(body):
				colliding_spider_array.erase(body)
				if colliding_spider_array.is_empty():
					spawn_allowed = true
					var mat : StandardMaterial3D = check_debug_spider.get_active_material(0)
					mat.albedo_color = Color(0,1,0,0.2)
