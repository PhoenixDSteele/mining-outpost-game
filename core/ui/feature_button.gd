class_name FeatureButton extends Button
## Button withe extra features, such as built in audio calls.
##

@export var useHighlightSound : bool = true
@export var highlightSoundModifier : float = -5.0
@export var useClickedSound : bool = true
@export var clickedSoundModifier : float = -5.0

func highlighted() -> void:
	if useHighlightSound == true:
		AudioManager.play_UI_sound("highlight", highlightSoundModifier)

func clicked() -> void:
	if useHighlightSound == true:
		AudioManager.play_UI_sound("clicked", clickedSoundModifier)
