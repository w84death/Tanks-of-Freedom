extends TileMap

var mouse_dragging = false
var pos = self.get_pos()

var sX = 0
var sY = 0
var k = 0.98
var target = Vector2(300,-46)

func _input(event):
	pos = self.get_pos()
	if(event.type == InputEvent.MOUSE_BUTTON):
		if (event.button_index == BUTTON_LEFT):
			mouse_dragging = event.pressed
			
	if (event.type == InputEvent.MOUSE_MOTION):
		if (mouse_dragging):
			pos.x = pos.x + event.relative_x / 2
			pos.y = pos.y + event.relative_y / 2
			target = pos
			self.set_pos(pos)
			print(pos.x,pos.y)

func _process(delta):
	if not pos == target:
		self.sX = self.k * self.sX + (1.0 - self.k) * target.x;
		self.sY = self.k * self.sY + (1.0 - self.k) * target.y;
		self.set_pos(Vector2(self.sX,self.sY))

func move_to(target):
	self.target = target;

func _ready():
	set_process_input(true)
	set_process(true)
	pass


