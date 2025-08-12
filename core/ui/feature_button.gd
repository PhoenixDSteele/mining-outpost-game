class_name FeatureButton extends Button
## Button withe extra features, such as built in audio calls.
##

@export var useHighlightSound : bool = true
@export var highlightSoundModifier : float = -5.0
@export var useClickedSound : bool = true
@export var clickedSoundModifier : float = -5.0

func highlighted() -> void:
	self.text = "<" + self.text + ">"
	if useHighlightSound == true:
		AudioManager.play_UI_sound(AudLib.ui.highlight)

func clicked() -> void:
	if useHighlightSound == true:
		AudioManager.play_UI_sound(AudLib.ui.clicked, clickedSoundModifier)


func _on_mouse_exited() -> void:
	self.text = self.text.lstrip("<")
	self.text = self.text.rstrip(">")
	self.release_focus()
