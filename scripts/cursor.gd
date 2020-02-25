extends Sprite

func _input(event):
	if(event is InputEventMouseButton):
		if (event.button_index == BUTTON_LEFT):
			if event.pressed:
				self.set_frame(1)
			else:
				self.set_frame(0)
	if (event is InputEventMouseMotion):
			self.set_position(Vector2(event.get_position().x, event.get_position().y))

func _ready():
	set_process_input(true)
	pass



