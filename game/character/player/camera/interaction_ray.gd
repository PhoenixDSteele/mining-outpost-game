class_name InteractionRay extends RayCast3D

@onready var interact_text: Label = %InteractText
@onready var crosshair: Label = $Crosshair/Crosshair

func _ready() -> void:
	interact_text.text = ""

func _process(_delta: float) -> void:
	
	if is_colliding():
		var collider = get_collider()
		if collider is Interactable:
			
			interact_text.text = collider.get_prompt()
			
			if Input.is_action_just_pressed("interact"):
				collider.interact()
		
		else:
			interact_text.text = ""
	else:
		interact_text.text = ""

func toggle_crosshair_visibility(visibility:bool) -> void:
	crosshair.visible = visibility
