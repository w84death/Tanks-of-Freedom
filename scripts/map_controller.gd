extends Control

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
var near_threshold = 0.4


var map_grass = [preload('res://terrain/grass_1.xscn'),preload('res://terrain/grass_2.xscn')]
var map_forest = [preload('res://terrain/forest_1.xscn'),preload('res://terrain/forest_2.xscn')]
var map_city = [preload('res://terrain/city_1.xscn'),preload('res://terrain/city_2.xscn'),preload('res://terrain/city_3.xscn'),preload('res://terrain/city_4.xscn'),preload('res://terrain/city_5.xscn')]
var map_mountain = [preload('res://terrain/mountain_1.xscn'),preload('res://terrain/mountain_2.xscn')]
var map_statue = preload('res://terrain/city_statue.xscn')
var map_flowers = [preload('res://terrain/flowers_1.xscn'),preload('res://terrain/flowers_2.xscn'),preload('res://terrain/flowers_3.xscn'),preload('res://terrain/flowers_4.xscn'),preload('res://terrain/log.xscn')]
var map_buildings = [preload('res://buildings/bunker_blue.xscn'),preload('res://buildings/bunker_red.xscn'),preload('res://buildings/barrack.xscn'),preload('res://buildings/factory.xscn'),preload('res://buildings/airport.xscn'),preload('res://buildings/tower.xscn'),preload('res://buildings/fence.xscn')]
var map_layer
var map_layer_units


func _input(event):
		
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
	if not pos == target:
		temp_delta += delta
		if temp_delta > map_step:
			var diff_x = target.x - self.sX
			var diff_y = target.y - self.sY
			if diff_x > -near_threshold && diff_x < near_threshold && diff_y > -near_threshold && diff_y < near_threshold:
				target = pos
			else:
				self.sX = self.sX + (diff_x) * temp_delta;
				self.sY = self.sY + (diff_y) * temp_delta;
				terrain.set_pos(Vector2(self.sX,self.sY))
				underground.set_pos(Vector2(self.sX,self.sY))
			temp_delta = 0

func move_to(target):
	if not mouse_dragging:
		self.target = target;

func move_to_map(target):
	if not mouse_dragging:
		game_size = get_node("/root/game").get_size()
		var target_position = self.map_to_world(target*Vector2(-1,-1)) + Vector2(game_size.x/(2*scale.x),game_size.y/(2*scale.y))
		var diff_x = target_position.x - self.sX
		var diff_y = target_position.y - self.sY
		var near_x = game_size.x * (near_threshold / scale.x)
		var near_y = game_size.y * (near_threshold / scale.y)
		# print(near_x)
		# print(diff_x)
		if diff_x > -near_x && diff_x < near_x && diff_y > -near_y && diff_y < near_y:
			return
		self.target = target_position

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

func generate_map():
	var map_max_x = 32
	var map_max_y = 32
	var temp = null
	var temp2 = null
	randomize()
	
	for x in range(map_max_x):
		for y in range(map_max_y):
		
			# grass, flowers, log
			if terrain.get_cell(x,y) == 1:
				temp = map_grass[randi() % 2].instance()
				temp2 = map_flowers[randi() % 4].instance()
			if terrain.get_cell(x,y) == 2:
				temp = map_forest[randi() % 2].instance()
				
			# mountains
			if terrain.get_cell(x,y) == 3:
				temp = map_mountain[randi() % 2].instance()
			
			if temp:
				temp.set_pos(terrain.map_to_world(Vector2(x,y)))
				map_layer.add_child(temp)
				temp = null
			if temp2:
				temp2.set_pos(terrain.map_to_world(Vector2(x,y)))
				map_layer.add_child(temp2)
				temp2 = null
				
			# city, statue
			if terrain.get_cell(x,y) == 4:
				temp = map_city[randi() % 5].instance()
			if terrain.get_cell(x,y) == 5:
				temp = map_statue.instance()
			
			# military buildings
			if terrain.get_cell(x,y) == 6: # HQ blue
				temp = map_buildings[0].instance()
			if terrain.get_cell(x,y) == 7: # HQ red
				temp = map_buildings[1].instance()
			if terrain.get_cell(x,y) == 8: # barrack
				temp = map_buildings[2].instance()
			if terrain.get_cell(x,y) == 9: # factory
				temp = map_buildings[3].instance()
			if terrain.get_cell(x,y) == 10: # airport
				temp = map_buildings[4].instance()
			if terrain.get_cell(x,y) == 11: # tower
				temp = map_buildings[5].instance()
				
			if temp:
				temp.set_pos(terrain.map_to_world(Vector2(x,y)))
				map_layer_units.add_child(temp)
				temp = null
			
			# roads
			
	return
	
func _ready():
	terrain = get_node("terrain")
	underground = get_node("underground")
	map_layer = terrain.get_node("plants")
	map_layer_units = terrain.get_node("units")
	scale = Vector2(2,2)
	terrain.set_scale(scale)
	underground.set_scale(scale)
	pos = terrain.get_pos()
	shake_timer.set_wait_time(shake_time / shakes_max)
	shake_timer.set_one_shot(true)
	shake_timer.set_autostart(false)
	shake_timer.connect('timeout', self, 'do_single_shake')
	self.add_child(shake_timer)
	self.generate_map()
	
	set_process_input(true)
	set_process(true)
	pass


