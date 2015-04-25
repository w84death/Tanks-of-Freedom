extends Control

export var show_blueprint = false
export var campaign_map = true
export var take_enemy_hq = true
export var control_all_towers = false
export var multiplayer_map = false

var terrain
var underground
var units
var fog_of_war
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
var near_threshold = 0.2
var pan_threshold = 60
var panning = false

var gen_grass = 6
var gen_flowers = 3

const MAP_MAX_X = 64
const MAP_MAX_Y = 64

var map_file = File.new()

var map_grass = [preload('res://terrain/grass_1.xscn'),preload('res://terrain/grass_2.xscn')]
var map_forest = [preload('res://terrain/forest_1.xscn'),preload('res://terrain/forest_2.xscn'),preload('res://terrain/forest_3.xscn'),preload('res://terrain/forest_4.xscn'),preload('res://terrain/forest_5.xscn')]
var map_city = [preload('res://terrain/city_1.xscn'),preload('res://terrain/city_2.xscn'),preload('res://terrain/city_3.xscn'),preload('res://terrain/city_4.xscn'),preload('res://terrain/city_5.xscn')]
var map_mountain = [preload('res://terrain/mountain_1.xscn'),preload('res://terrain/mountain_2.xscn'),preload('res://terrain/mountain_3.xscn'),preload('res://terrain/mountain_4.xscn')]
var map_statue = preload('res://terrain/city_statue.xscn')
var map_flowers = [preload('res://terrain/flowers_1.xscn'),preload('res://terrain/flowers_2.xscn'),preload('res://terrain/flowers_3.xscn'),preload('res://terrain/flowers_4.xscn'),preload('res://terrain/log.xscn'),preload('res://terrain/flowers_5.xscn'),preload('res://terrain/flowers_6.xscn'),preload('res://terrain/flowers_7.xscn')]
var map_buildings = [preload('res://buildings/bunker_blue.xscn'),preload('res://buildings/bunker_red.xscn'),preload('res://buildings/barrack.xscn'),preload('res://buildings/factory.xscn'),preload('res://buildings/airport.xscn'),preload('res://buildings/tower.xscn'),preload('res://buildings/fence.xscn')]
var map_units = [preload('res://units/soldier_blue.xscn'),preload('res://units/tank_blue.xscn'),preload('res://units/helicopter_blue.xscn'),preload('res://units/soldier_red.xscn'),preload('res://units/tank_red.xscn'),preload('res://units/helicopter_red.xscn')]

func _input(event):

	pos = terrain.get_pos()
	if(event.type == InputEvent.MOUSE_BUTTON):
		if ((show_blueprint and event.button_index == BUTTON_RIGHT) or (not show_blueprint and event.button_index == BUTTON_LEFT)):
			mouse_dragging = event.pressed

	if (event.type == InputEvent.MOUSE_MOTION):
		if (mouse_dragging):
			pos.x = pos.x + event.relative_x / scale.x
			pos.y = pos.y + event.relative_y / scale.y
			target = pos
			underground.set_pos(target)
			terrain.set_pos(target)
			fog_of_war.set_pos(target)


func _process(delta):
	if not pos == target:
		temp_delta += delta
		if temp_delta > map_step:
			var diff_x = target.x - self.sX
			var diff_y = target.y - self.sY

			if diff_x > -pan_threshold && diff_x < pan_threshold && diff_y > -pan_threshold && diff_y < pan_threshold:
				panning = false
			else:
				panning = true

			if diff_x > -near_threshold && diff_x < near_threshold && diff_y > -near_threshold && diff_y < near_threshold:
				target = pos
			else:
				self.sX = self.sX + (diff_x) * temp_delta;
				self.sY = self.sY + (diff_y) * temp_delta;
				terrain.set_pos(Vector2(self.sX,self.sY))
				underground.set_pos(Vector2(self.sX,self.sY))
				fog_of_war.set_pos(Vector2(self.sX,self.sY))
			temp_delta = 0
	else:
		panning = false

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

		# FOG OF WAR
	for x in range(-MAP_MAX_X,MAP_MAX_X):
		for y in range(-MAP_MAX_Y,MAP_MAX_Y):
			fog_of_war.set_cell(x,y,0)

	for x in range(MAP_MAX_X):
		for y in range(MAP_MAX_Y):

			# underground
			if terrain.get_cell(x,y) > -1:
				self.generate_underground(x,y)

			# grass, flowers, log
			if terrain.get_cell(x,y) == 1:
				if ( randi() % 10 ) <= gen_grass:
					temp = map_grass[randi() % map_grass.size()].instance()
				if ( randi() % 10 ) <= gen_flowers:
					temp2 = map_flowers[randi() % map_flowers.size()].instance()

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
				temp = map_forest[randi() % map_forest.size()].instance()
				cells_to_change.append({x=x,y=y,type=1})

			# mountains
			if terrain.get_cell(x,y) == 3:
				temp = map_mountain[randi() % map_mountain.size()].instance()
				cells_to_change.append({x=x,y=y,type=1})

			# city, statue
			if terrain.get_cell(x,y) == 4:
				temp = map_city[randi() % map_city.size()].instance()
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
				self.find_spawn_for_building(x, y, temp)
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

func clear_fog(center_x,center_y,size):
	var x_min = center_x-size
	var x_max = center_x+size
	var y_min = center_y-size
	var y_max = center_y+size
	
	for x in range(x_min,x_max):
		for y in range(y_min,y_max):
			fog_of_war.set_cell(x,y,-1)
			#if x == x_min and y == y_min:
			#	fog_of_war.set_cell(x,y,2)
			
	return

func find_spawn_for_building(x, y, building):
	if building.group != "building":
		return
	if building.can_spawn == false:
		return
	print('looking for spawn')
	self.look_for_spawn(x, y, 1, 0, building)
	self.look_for_spawn(x, y, 0, 1, building)
	self.look_for_spawn(x, y, -1, 0, building)
	self.look_for_spawn(x, y, 0, -1, building)

func look_for_spawn(x, y, offset_x, offset_y, building):
	var cell = terrain.get_cell(x + offset_x, y + offset_y)
	print(cell);
	if cell == 13:
		building.spawn_point_position = Vector2(offset_x, offset_y)
		building.spawn_point = Vector2(x + offset_x, y + offset_y)

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
	self.clear_fog(x,y,3)
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
	self.scale = Vector2(2,2)

func save_map(file_name):
	var temp_data = []
	var temp_terrain = -1
	var temp_unit = -1

	file_name = str(file_name)

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
		var the_file = map_file.open("user://"+file_name+".tof",File.WRITE)
		print('the_file',the_file)
		map_file.store_var(temp_data)
		map_file.close()
		print('ToF: map saved to file')
		return true
	else:
		print('ToF: wrong file name')
		return false

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
	var file_path = "user://"+file_name+".tof"
	return self.load_map_from_file(file_path)

func load_resource_map(file_name):
	var file_path = "res://maps/blueprints/"+file_name+".tof"
	self.load_map_from_file(file_path)

func load_map_from_file(file_path):
	var temp_data
	var cell
	self.init_nodes()

	if map_file.file_exists(file_path):
		map_file.open(file_path, File.READ)
		temp_data = map_file.get_var()
		terrain.clear()
		units.clear()
		for cell in temp_data:
			if cell.terrain > -1:
				terrain.set_cell(cell.x,cell.y,cell.terrain)
			if cell.unit > -1:
				units.set_cell(cell.x,cell.y,cell.unit)
		units.raise()
		print('ToF: map ' + file_path + ' loaded from file')
		map_file.close()
		return true
	else:
		print('ToF: map file not exists!')
		return false

func fill(width,height):
	terrain.clear()
	units.clear()
	for x in range(width):
		for y in range(height):
			terrain.set_cell(x,y,1)

func clear_layer(layer):
	if layer == 0:
		units.clear()
		terrain.clear()
	if layer == 1:
		units.clear()

func init_nodes():
	underground = self.get_node("underground")
	terrain = self.get_node("terrain")
	units = terrain.get_node("units")
	fog_of_war = self.get_node("fog_of_war")
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


