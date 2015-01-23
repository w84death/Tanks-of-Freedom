extends TileMap

var mouse_dragging = false
var pos = self.get_pos()
var scale = 3

func _input(event):
	if(event.type == InputEvent.MOUSE_BUTTON):
		if (event.button_index == BUTTON_RIGHT):
			mouse_dragging = event.pressed
			
	if (event.type == InputEvent.MOUSE_MOTION):
		if (mouse_dragging):
			pos.x = pos.x + event.relative_x
			pos.y = pos.y + event.relative_y
			self.set_pos(pos)
		print( 'mouse over: ',self.world_to_map( Vector2((event.x/scale)-pos.x,(event.y/scale)-pos.y)))

func _ready():
	set_process_input(true)	
	pass


