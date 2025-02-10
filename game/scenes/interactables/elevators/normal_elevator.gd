class_name NormalElevator extends Node3D

@export var elevator_ride_duration : float = 1.0
@export var elevator_up : bool = true

@onready var elevator: MeshInstance3D = %Elevator
@onready var top_location: Marker3D = %TopLocation
@onready var bot_location: Marker3D = %BotLocation

var moving : bool = false

func _ready() -> void:
	if elevator_up:
		elevator.position = top_location.position
	elif not elevator_up:
		elevator.position = bot_location.position

func active_elevator() -> void:
	if elevator_up:
		move_down()
	elif not elevator_up:
		move_up()

func move_up() -> void:
	if not moving:
		var tween = get_tree().create_tween()
		moving = true
		tween.tween_property(elevator, "position:y", top_location.position.y, elevator_ride_duration)
		tween.tween_callback(func(): moving = false)
		tween.tween_callback(func(): elevator_up = true)

func move_down() -> void:
	if not moving:
		var tween = get_tree().create_tween()
		moving = true
		tween.tween_property(elevator, "position:y", bot_location.position.y, elevator_ride_duration)
		tween.tween_callback(func(): moving = false)
		tween.tween_callback(func(): elevator_up = false)
