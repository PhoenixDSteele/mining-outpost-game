class_name PlayerMenu extends MeshInstance3D
## Not my script Modified from linked source below.  -Phoenix
## Source: https://github.com/godotengine/godot-demo-projects/blob/master/viewport/gui_in_3d/gui_3d.gd

## Reference to UI
@onready var information_screen: InformationScreen = $MenuViewport/information_screen

## Used for checking if the mouse is inside the Area3D.
var is_mouse_inside := false

## The last processed input touch/mouse event. Used to calculate relative movement.
var last_event_pos2D := Vector2()

## The time of the last event in seconds since engine start.
var last_event_time := -1.0

@onready var menu_effect: ColorRect = %MenuEffect
@onready var menu_viewport: SubViewport = %MenuViewport
@onready var menu_area: Area3D = %menu_area

func _ready() -> void:
	menu_area.mouse_entered.connect(_mouse_entered_area)
	menu_area.mouse_exited.connect(_mouse_exited_area)
	menu_area.input_event.connect(_mouse_input_event)

	# Sets the texture manually to avoid a known bug. https://www.reddit.com/r/godot/comments/13d93o1/godot_4_viewport_texture_error/
	set_viewport_mat(self, menu_viewport)

func setup_map_cam(player:BodyBase):
	player.map_viewport.reparent(information_screen.map.map_container)
	information_screen.map.held_viewport = player.map_viewport

func return_map_cam() -> SubViewport:
	return information_screen.map.held_viewport

func set_viewport_mat(display_mesh : MeshInstance3D, sub_viewport : SubViewport, surface_id : int = 0):
	var mat : StandardMaterial3D = StandardMaterial3D.new()
	mat.resource_local_to_scene = true
	mat.albedo_texture = sub_viewport.get_texture()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	display_mesh.set_surface_override_material(surface_id, mat)

func _mouse_entered_area() -> void:
	print("it touched")
	is_mouse_inside = true
	# Notify the viewport that the mouse is now hovering it.
	menu_viewport.notification(NOTIFICATION_VP_MOUSE_ENTER)

func _mouse_exited_area() -> void:
	# Notify the viewport that the mouse is no longer hovering it.
	menu_viewport.notification(NOTIFICATION_VP_MOUSE_EXIT)
	is_mouse_inside = false


func _unhandled_input(event: InputEvent) -> void:
	# Check if the event is a non-mouse/non-touch event
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if is_instance_of(event, mouse_event):
			# If the event is a mouse/touch event, then we can ignore it here, because it will be
			# handled via Physics Picking.
			return
	menu_viewport.push_input(event)


func _mouse_input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	# Get mesh size to detect edges and make conversions. This code only supports PlaneMesh and QuadMesh.
	var quad_mesh_size: Vector2 = self.mesh.size

	# Event position in Area3D in world coordinate space.
	var event_pos3D := event_position

	# Current time in seconds since engine start.
	var now := Time.get_ticks_msec() / 1000.0

	# Convert position to a coordinate space relative to the Area3D node.
	# NOTE: `affine_inverse()` accounts for the Area3D node's scale, rotation, and position in the scene!
	event_pos3D = self.global_transform.affine_inverse() * event_pos3D

	# TODO: Adapt to bilboard mode or avoid completely.

	var event_pos2D := Vector2()

	if is_mouse_inside:
		# Convert the relative event position from 3D to 2D.
		event_pos2D = Vector2(event_pos3D.x, -event_pos3D.y)

		# Right now the event position's range is the following: (-quad_size/2) -> (quad_size/2)
		# We need to convert it into the following range: -0.5 -> 0.5
		event_pos2D.x = event_pos2D.x / quad_mesh_size.x
		event_pos2D.y = event_pos2D.y / quad_mesh_size.y
		# Then we need to convert it into the following range: 0 -> 1
		event_pos2D.x += 0.5
		event_pos2D.y += 0.5

		# Finally, we convert the position to the following range: 0 -> viewport.size
		event_pos2D.x *= menu_viewport.size.x
		event_pos2D.y *= menu_viewport.size.y
		# We need to do these conversions so the event's position is in the viewport's coordinate system.

	elif last_event_pos2D != null:
		# Fall back to the last known event position.
		event_pos2D = last_event_pos2D

	# Set the event's position and global position.
	event.position = event_pos2D
	if event is InputEventMouse:
		event.global_position = event_pos2D

	# Calculate the relative event distance.
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		# If there is not a stored previous position, then we'll assume there is no relative motion.
		if last_event_pos2D == null:
			event.relative = Vector2(0, 0)
		# If there is a stored previous position, then we'll calculate the relative position by subtracting
		# the previous position from the new position. This will give us the distance the event traveled from prev_pos.
		else:
			event.relative = event_pos2D - last_event_pos2D
			event.velocity = event.relative / (now - last_event_time)

	# Update last_event_pos2D with the position we just calculated.
	last_event_pos2D = event_pos2D

	# Update last_event_time to current time.
	last_event_time = now

	# Finally, send the processed input event to the viewport.
	menu_viewport.push_input(event)

func _on_visibility_changed() -> void:
	
	#menu_effect.visible = self.visible
	
	if (self.visible == true):
		information_screen.check_game_instance()
