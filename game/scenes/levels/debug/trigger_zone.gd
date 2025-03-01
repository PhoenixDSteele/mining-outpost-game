class_name TriggerZone extends Area3D

enum NamedEnum {Dialogue, Event = -1}
@export var TriggerType: NamedEnum
@export var trigger_id : int = 0
@export var dialogue : CommDialogue = null

var activated : bool = false
var triggering_body : BodyBase = null

func _on_trigger_zone_entered(body: Node3D) -> void:
	if (body is BodyBase) and (not activated):
		triggering_body = body
		if TriggerType == NamedEnum.Dialogue:
			if triggering_body.hud.hud_datapad.datapad_active == true:
				triggering_body.hud.hud_dialogue.dialogue_finished.connect(resume_active_datapad)
				triggering_body.hud.hud_datapad.pause_data_pad()
			activated = true
			triggering_body.hud.hud_dialogue.play_comm_dialogue(dialogue)

func resume_active_datapad():
	triggering_body.hud.hud_datapad.resume_data_pad()
	triggering_body.hud.hud_dialogue.dialogue_finished.disconnect(resume_active_datapad)
