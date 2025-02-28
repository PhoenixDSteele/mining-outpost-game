class_name TriggerZone extends Area3D

enum NamedEnum {Dialogue, Event = -1}
@export var TriggerType: NamedEnum
@export var trigger_id : int = 0

@export var dialogue : CommDialogue = null

var active : bool = true

func _on_trigger_zone_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if TriggerType == NamedEnum.Dialogue:
			body.hud.hud_dialogue.play_comm_dialogue(dialogue)
