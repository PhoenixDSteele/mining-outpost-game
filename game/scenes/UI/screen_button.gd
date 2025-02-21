class_name ScreenButton extends Button

@export var mouseover : AudioStream
@export var clicked : AudioStream


var sound : AudioStreamPlayer

func _ready():
	print('ready')
	sound = AudioStreamPlayer.new()
	sound.volume_db -= 10
	sound.bus = "UI"
	add_child(sound)
	
	self.pressed.connect(button_clicked)
	self.mouse_entered.connect(button_hovered)

func button_clicked():
	sound.stream = clicked
	sound.play()

func button_hovered():
	sound.stream = mouseover
	sound.play()
