extends TileMap

var mouse_dragging = false
var pos = self.get_pos()

func _input(event):
	if(event.type == InputEvent.MOUSE_BUTTON):
		if (event.button_index == BUTTON_RIGHT):
			mouse_dragging = event.pressed
			
	if (event.type == InputEvent.MOUSE_MOTION):
		if (mouse_dragging):
			pos.x = pos.x + event.relative_x
			pos.y = pos.y + event.relative_y
			self.set_pos(pos)

func _ready():
	set_process_input(true)
	pass


