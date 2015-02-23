extends TileMap

var terrain
var underground

var mouse_dragging = false
var pos
var game_size
var scale
var root

var sX = 0
var sY = 0
var k = 0.90
var target = Vector2(0,0)

var shake_timer = Timer.new()
var shakes = 0
export var shakes_max = 5
export var shake_time = 0.25
export var shake_boundary = 5
var shake_initial_position
var temp_delta = 0
var map_step = 0.01

func _input(event):
	if root.is_paused:
		return
		
	pos = terrain.get_pos()
	if(event.type == InputEvent.MOUSE_BUTTON):
		if (event.button_index == BUTTON_LEFT):
			mouse_dragging = event.pressed
			
	if (event.type == InputEvent.MOUSE_MOTION):
		if (mouse_dragging):
			pos.x = pos.x + event.relative_x / scale.x
			pos.y = pos.y + event.relative_y / scale.y
			target = pos
			underground.set_pos(target)
			terrain.set_pos(target)


func _process(delta):
	temp_delta += delta
	if not pos == target and temp_delta > map_step:
		self.sX = self.sX - (self.sX - target.x) * temp_delta;
		self.sY = self.sY - (self.sY - target.y) * temp_delta;
		terrain.set_pos(Vector2(self.sX,self.sY))
		underground.set_pos(Vector2(self.sX,self.sY))
		temp_delta = 0

func move_to(target):
	if not mouse_dragging:
		self.target = target;

func move_to_map(target):
	if not mouse_dragging:
		game_size = get_node("/root/game").get_size()
		var target_position = self.map_to_world(target*Vector2(-1,-1))
		self.target = target_position + Vector2(game_size.x/(2*scale.x),game_size.y/(2*scale.y))

func shake_camera():
	if root.settings['shake_enabled'] and not mouse_dragging:
		shakes = 0
		shake_initial_position = terrain.get_pos()
		self.do_single_shake()
	
func do_single_shake():
	if shakes < shakes_max:
		var direction_x = randf()
		var direction_y = randf()
		var distance_x = randi() % shake_boundary
		var distance_y = randi() % shake_boundary
		if direction_x <= 0.5:
			distance_x = -distance_x
		if direction_y <= 0.5:
			distance_y = -distance_y
		
		pos = Vector2(shake_initial_position) + Vector2(distance_x, distance_y)
		target = pos
		underground.set_pos(pos)
		terrain.set_pos(pos)
		shakes += 1
		shake_timer.start()
	else:
		pos = shake_initial_position
		target = pos
		underground.set_pos(shake_initial_position)
		terrain.set_pos(shake_initial_position)

	
func _ready():
	root = get_node("/root/game")
	terrain = root.current_map_terrain
	underground = root.current_map.get_node("underground")
	scale = root.scale_root.get_scale()
	pos = terrain.get_pos()
	shake_timer.set_wait_time(shake_time / shakes_max)
	shake_timer.set_one_shot(true)
	shake_timer.set_autostart(false)
	shake_timer.connect('timeout', self, 'do_single_shake')
	self.add_child(shake_timer)
	set_process_input(true)
	set_process(true)
	pass


