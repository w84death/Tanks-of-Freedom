
extends AnimatedSprite
var selected=false

func _input(event):
	if (event.type==InputEvent.MOUSE_BUTTON and event.pressed):
		selected = not selected
		print('unit selected ')

func _ready():
	set_process_input(true)
	pass


