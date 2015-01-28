
extends Sprite

func _input(event):
	if(event.type == InputEvent.MOUSE_BUTTON):
		if (event.button_index == BUTTON_LEFT):
			if event.pressed:
				self.set_frame(1)
			else:
				self.set_frame(0)
	if (event.type == InputEvent.MOUSE_MOTION):
			self.set_pos(Vector2(event.x, event.y))

func _ready():
	set_process_input(true)
	pass


