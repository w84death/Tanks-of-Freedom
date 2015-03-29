extends Control

export var show_blueprint = false
export var campaign_map = true
export var take_enemy_hq = true
export var control_all_towers = false
export var multiplayer_map = false

var terrain
var underground
var units
var map_layer_back
var map_layer_front

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

export var gen_grass = 7
export var gen_flowers = 5
const MAP_MAX_X = 64
const MAP_MAX_Y = 64

var map_file = File.new()

var map_grass = [preload('res://terrain/grass_1.xscn'),preload('res://terrain/grass_2.xscn')]
var map_forest = [preload('res://terrain/forest_1.xscn'),preload('res://terrain/forest_2.xscn')]
var map_city = [preload('res://terrain/city_1.xscn'),preload('res://terrain/city_2.xscn'),preload('res://terrain/city_3.xscn'),preload('res://terrain/city_4.xscn'),preload('res://terrain/city_5.xscn')]
var map_mountain = [preload('res://terrain/mountain_1.xscn'),preload('res://terrain/mountain_2.xscn')]
var map_statue = preload('res://terrain/city_statue.xscn')
var map_flowers = [preload('res://terrain/flowers_1.xscn'),preload('res://terrain/flowers_2.xscn'),preload('res://terrain/flowers_3.xscn'),preload('res://terrain/flowers_4.xscn'),preload('res://terrain/log.xscn')]
var map_buildings = [preload('res://buildings/bunker_blue.xscn'),preload('res://buildings/bunker_red.xscn'),preload('res://buildings/barrack.xscn'),preload('res://buildings/factory.xscn'),preload('res://buildings/airport.xscn'),preload('res://buildings/tower.xscn'),preload('res://buildings/fence.xscn')]
var map_units = [preload('res://units/soldier_blue.xscn'),preload('res://units/tank_blue.xscn'),preload('res://units/helicopter_blue.xscn'),preload('res://units/soldier_red.xscn'),preload('res://units/tank_red.xscn'),preload('res://units/helicopter_red.xscn')]

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
		var target_position = terrain.map_to_world(target*Vector2(-1,-1)) + Vector2(game_size.x/(2*scale.x),game_size.y/(2*scale.y))
		var diff_x = target_position.x - self.sX
		var diff_y = target_position.y - self.sY
		var near_x = game_size.x * (near_threshold / scale.x)
		var near_y = game_size.y * (near_threshold / scale.y)

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
	var temp = null
	var temp2 = null
	var cells_to_change = []
	var cell
	randomize()
	
	for x in range(MAP_MAX_X):
		for y in range(MAP_MAX_Y):

			# underground
			if terrain.get_cell(x,y) > -1:
				self.generate_underground(x,y)

			# grass, flowers, log
			if terrain.get_cell(x,y) == 1:
				if randi() % 10 <= gen_grass:
					temp = map_grass[randi() % 2].instance()
				if randi() % 10 <= gen_flowers:
					temp2 = map_flowers[randi() % 4].instance()
					
			if temp:
				temp.set_pos(terrain.map_to_world(Vector2(x,y)))
				map_layer_back.add_child(temp)
				temp = null
			if temp2:
				temp2.set_pos(terrain.map_to_world(Vector2(x,y)))
				map_layer_back.add_child(temp2)
				temp2 = null

			# forest
			if terrain.get_cell(x,y) == 2:
				temp = map_forest[randi() % 2].instance()
				cells_to_change.append({x=x,y=y,type=1})
				
			# mountains
			if terrain.get_cell(x,y) == 3:
				temp = map_mountain[randi() % 2].instance()
				cells_to_change.append({x=x,y=y,type=1})

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
				map_layer_front.add_child(temp)
				temp = null
			
			# roads
			if terrain.get_cell(x,y) == 14: # city road
				cells_to_change.append({x=x,y=y,type=self.build_sprite_path(x,y,[14, 16, -1, 18])})
			if terrain.get_cell(x,y) == 15: # country road
				cells_to_change.append({x=x,y=y,type=self.build_sprite_path(x,y,[15, 16, -1, 18])})
			if terrain.get_cell(x,y) == 16: # road mix
				cells_to_change.append({x=x,y=y,type=self.build_sprite_path(x,y,[16, 14])})
			if terrain.get_cell(x,y) == 17: # river
				cells_to_change.append({x=x,y=y,type=self.build_sprite_path(x,y,[17, 18])})
			if terrain.get_cell(x,y) == 18: # bridge
				cells_to_change.append({x=x,y=y,type=self.build_sprite_path(x,y,[18, 17])})
			
			if units.get_cell(x,y) > -1:
				self.spawn_unit(x,y,units.get_cell(x,y))
	
	for cell in cells_to_change:
		if(cell.type):
			terrain.set_cell(cell.x,cell.y,cell.type)
	units.hide()
	return

func build_sprite_path(x,y,type):
	var position = 0
	
	if terrain.get_cell(x,y-1) in type:
		position += 2
	if terrain.get_cell(x+1,y) in type:
		position += 4
	if terrain.get_cell(x,y+1) in type:
		position += 8
	if terrain.get_cell(x-1,y) in type:
		position += 16
		
	# road
	if type[0] == 14: 
		if position in [10,2,8]:
			return 19
		if position in [20,16,4]:
			return 20
		if position == 24:
			return 21
		if position == 12:
			return 22
		if position == 18:
			return 23
		if position == 6:
			return 24
		if position == 26:
			return 25
		if position == 28:
			return 26
		if position == 14:
			return 27
		if position == 22:
			return 28
		if position == 30:
			return 29
	
	# coutry road
	if type[0] == 15:
		if position in [10,2,8]:
			return 36
		if position in [20,16,4]:
			return 37
		if position == 24:
			return 38
		if position == 12:
			return 39
		if position == 18:
			return 40
		if position == 6:
			return 41
		if position == 26:
			return 42
		if position == 28:
			return 43
		if position == 14:
			return 44
		if position == 22:
			return 45
		if position == 30:
			return 46
	
	# road mix
	if type[0] == 16:
		if position == 2:
			return 32
		if position == 16:
			return 33
		if position == 8:
			return 34
		if position == 4:
			return 35

	# river
	if type[0] == 17:
		if position in [10,2,8]:
			if randi() % 4  > 2:
				return 47
			else:
				return 53
		if position in [20,16,4]:
			if randi() % 4  > 2:
				return 48
			else:
				return 54
		if position == 24:
			return 49
		if position == 12:
			return 50
		if position == 18:
			return 51
		if position == 6:
			return 52

	# bridge
	if type[0] == 18:
		if position in [10,2,8]:
			return 31
		if position in [20,16,4]:
			return 30
	
	# nothing to change
	return false

func spawn_unit(x,y,type):
	var temp = map_units[type].instance()
	temp.set_pos(terrain.map_to_world(Vector2(x,y)))
	map_layer_front.add_child(temp)
	temp = null
	return

func generate_underground(x,y):
	var generate = false
	
	if terrain.get_cell(x,y-1) == -1:
		generate = true
	if terrain.get_cell(x+1,y) == -1:
		generate = true
	if terrain.get_cell(x,y+1) == -1:
		generate = true
	if terrain.get_cell(x-1,y) == -1:
		generate = true
	
	if generate:
		underground.set_cell(x+1,y+1,0)

func set_default_zoom():
	scale = Vector2(2,2)
	terrain.set_scale(scale)
	underground.set_scale(scale)
	self.scale = scale

func save_map(file_name):
	var temp_data = []
	var temp_terrain = -1
	var temp_unit = -1
	
	for x in range(MAP_MAX_X):
		for y in range(MAP_MAX_Y):
			if terrain.get_cell(x,y) > -1:
				temp_terrain = terrain.get_cell(x,y)
			
			if units.get_cell(x,y) > -1:
				temp_unit = units.get_cell(x,y)
			
			if temp_terrain or temp_unit:
				temp_data.append({
					x=x,y=y,
					terrain=temp_terrain,
					unit=temp_unit
				})
			
			temp_terrain = -1
			temp_unit = -1
	
	if self.check_file_name(file_name):
		map_file.open("user://"+file_name+".tof",File.WRITE)
		map_file.store_var(temp_data)
		map_file.close()
		print('ToF: map saved to file')
	else:
		print('ToF: wrong file name')
	return

func check_file_name(name):
	# we need to check here for unusual charracters
	# and trim spaces, convert to lower case etc
	# allowed: [a-z] and "-"
	# and can not name 'settings' !!!
	if not name == "":
		return true
	else:
		return false

func load_map(file_name):
	var temp_data
	var cell
	self.init_nodes()
	
	if map_file.file_exists("user://"+file_name+".tof"):
		map_file.open("user://"+file_name+".tof",File.READ)
		temp_data = map_file.get_var()
		terrain.clear()
		units.clear()
		for cell in temp_data:
			if cell.terrain > -1:
				terrain.set_cell(cell.x,cell.y,cell.terrain)
			if cell.unit > -1:
				units.set_cell(cell.x,cell.y,cell.unit)
		units.raise()
		print('ToF: map loaded from file')
		map_file.close()
	else:
		print('ToF: map file not exists!')
	return

func init_nodes():
	underground = self.get_node("underground")
	terrain = self.get_node("terrain")
	units = terrain.get_node("units")
	map_layer_back = terrain.get_node("back")
	map_layer_front = terrain.get_node("front")

func _ready():
	root = get_node("/root/game")
	self.init_nodes()
	if root:
		scale = root.scale_root.get_scale()
	else:
		self.set_default_zoom()
	pos = terrain.get_pos()
	shake_timer.set_wait_time(shake_time / shakes_max)
	shake_timer.set_one_shot(true)
	shake_timer.set_autostart(false)
	shake_timer.connect('timeout', self, 'do_single_shake')
	self.add_child(shake_timer)
	
	# where the magic happens
	if not show_blueprint:
		self.generate_map()
	
	set_process_input(true)
	set_process(true)
	pass


