extends TileMap

var terrain
var underground

var mouse_dragging = false
var pos
var game_size
var scale

var sX = 0
var sY = 0
var k = 0.98
var target = Vector2(0,0)

func _input(event):
	pos = terrain.get_pos()
	if(event.type == InputEvent.MOUSE_BUTTON):
		if (event.button_index == BUTTON_LEFT):
			mouse_dragging = event.pressed
			
	if (event.type == InputEvent.MOUSE_MOTION):
		if (mouse_dragging):
			pos.x = pos.x + event.relative_x / 2
			pos.y = pos.y + event.relative_y / 2
			target = pos
			underground.set_pos(target)
			terrain.set_pos(target)


func _process(delta):
	if not pos == target:
		self.sX = self.k * self.sX + (1.0 - self.k) * target.x;
		self.sY = self.k * self.sY + (1.0 - self.k) * target.y;
		terrain.set_pos(Vector2(self.sX,self.sY))
		underground.set_pos(Vector2(self.sX,self.sY))

func move_to(target):
	self.target = target;

func move_to_map(target):
	game_size = get_node("/root/game").get_size()
	var target_position = self.map_to_world(target*Vector2(-1,-1))
	self.target = target_position + Vector2(game_size.x/(2*scale.x),game_size.y/(2*scale.y))
	
	
func _ready():
	var root = get_node("/root/game")
	terrain = root.current_map_terrain
	underground = root.current_map.get_node("underground")
	scale = root.scale_root.get_scale()
	pos = terrain.get_pos()
	set_process_input(true)
	set_process(true)
	pass


