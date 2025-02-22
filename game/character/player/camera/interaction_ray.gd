class_name InteractionRay extends RayCast3D

@export var camera_user : CharacterBody3D

@onready var target_info: Control = $Crosshair
@onready var interact_text: Label = %InteractText
@onready var crosshair: Label = $Crosshair/Crosshair

var interacted_object : Interactable = null

var buffer_array : Array

func _process(_delta: float) -> void:
	
	if is_colliding():
		var collider = get_collider()

		if collider is Interactable:
			
			interact_text.text = collider.get_prompt()
			
			if Input.is_action_just_pressed("interact"):
				collider.interact()
				if collider is KeyPad:
					interacted_object = collider
					collider.connect("successful", return_control)
					if camera_user is BodyBase:
						camera_user.visual.visible = false
						camera_user.player_controller.input_disabled = true
						camera_user.ui_controller.menu_disabled = true
						target_info.visible = false
					if camera_user is SpiderHand:
						print('spider_used')
						camera_user.disabled = true
						target_info.visible = false
		elif collider is Area3D:
			if collider.name == "SpiderReturn":
				interact_text.text = "Return"
				if Input.is_action_just_pressed("interact"):
					if camera_user is SpiderHand:
						camera_user.state_ref.return_to_idle()
						self.queue_free()
	else:
		interact_text.text = ""

func toggle_crosshair_visibility(visibility:bool) -> void:
	crosshair.visible = visibility

func return_control() -> void:
	target_info.visible = true
	camera_user.player_camera.camera.make_current()
	
	if interacted_object is KeyPad:
		interacted_object.disconnect("successful", return_control)
	
	if camera_user is BodyBase:
		camera_user.visual.visible = true
		camera_user.player_controller.input_disabled = false
		camera_user.ui_controller.menu_disabled = false
	if camera_user is SpiderHand:
		camera_user.disabled = false
