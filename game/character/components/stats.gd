class_name Stats extends Node

var health : float = 100
var agility : float = 10
var strength : float = 10

func _ready() -> void:
	pass
	# Insert code here later to read from a source.
	# Source will be a stat sheet if it's AI, or a save-game if it's the player.
	# Otherwise the 100, 10, 10, will be the base stats unmodified.
