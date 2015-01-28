extends TileMap

var mouse_dragging = false
var pos = self.get_pos()
var game_size
var scale

var sX = 0
var sY = 0
var k = 0.98
var target = Vector2(0,0)

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

func move_to_map(target):
	game_size = get_node("/root/game").get_size()
	var target_position = self.map_to_world(target*Vector2(-1,-1))
	self.target = target_position + Vector2(game_size.x/(2*scale.x),game_size.y/(2*scale.y))
	
	
func _ready():
	scale = get_node("/root/game/pixel_scale").get_scale()
	self.move_to_map(Vector2(1,12))
	set_process_input(true)
	set_process(true)
	pass


