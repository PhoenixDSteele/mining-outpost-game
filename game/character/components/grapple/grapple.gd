class_name Grapple extends Node3D
## Connects to the player controller, reads input and uses a raycast to create points.


@onready var player: BodyBase = $"../../../../../.."
@onready var camera: Camera3D = %Camera3D

@export var player_controller : PlayerController = null
@export var grapple_max_length : float = 10
@export_flags_3d_physics var hit_layers

var cable : Cable

var grapple_attempt : bool = false
var grappling : bool = false
var reeling_in : bool = false
var attached_object : RigidBody3D = null
var attached_pos : Vector3 = Vector3.ZERO

func _ready() -> void:
	player_controller.input.connect(grapple)
	player_controller.input.connect(reel_in)

## Handles Input
func grapple(grapple_input) -> void:
	if grapple_input is String:
		if (grapple_input == "grapple_toggle"):
			if not grappling:
				grapple_attempt = true
				await get_tree().physics_frame # Awaits two physic frames, to get a single raycast + attach.
				await get_tree().physics_frame
				grapple_attempt = false
			elif grappling:
				grappling = false
				print('Releasing Grapple')

## Handles reeling input
func reel_in(reel_input) -> void:
	if reel_input is String:
		if (reel_input == "grapple_reel"):
			reeling_in = true
		elif (reel_input == "grapple_reel_stop"):
			reeling_in = false

## Handles raycast, grapple, distance, and reeling.
func _physics_process(delta: float) -> void:
	if grapple_attempt:
		var space_state = get_world_3d().direct_space_state
		var mousepos = get_viewport().get_mouse_position()

		var origin = camera.project_ray_origin(mousepos)
		var end = origin + camera.project_ray_normal(mousepos) * grapple_max_length
		var query = PhysicsRayQueryParameters3D.create(origin, end, hit_layers)
		query.collide_with_areas = true
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result:
			if result.collider != null:
				print("Grappling Ray Active")
				print(result.collider)
				if result.collider is KeyItem: # Picks up items.
					result.collider._on_interacted()
					print('its an item!')
				if result.collider is RigidBody3D: # Attaches to rigidbodies
					grappling = true
					attach_grapple(result.collider)
	if grappling:
		cable.update_pos(self.global_position, attached_object.global_position)
		if (player.global_position.distance_to(attached_object.global_position) > (grapple_max_length - 1)) or (reeling_in):
			attached_object.apply_central_force((player.global_position - attached_object.global_position) * delta * 100)
		else:
			attached_object.constant_force = Vector3.ZERO
		if cable != null:
			cable.update_pos(self.global_position, attached_object.global_position)
	else:
		if cable:
			cable.queue_free()
			cable = null


## Attaches to first rigidbody hit if it was detected as a rigidbody.
func attach_grapple(body:RigidBody3D) -> void:
	attached_object = body
	cable = Cable.new()
	cable.top_level = true
	cable.create_cable(self.global_position, attached_object.global_position)
	add_child(cable)
	print('attached to: ' + str(body.name))
