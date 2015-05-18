var fog_of_war
var map_controller
var terrain
var root

var fog_pattern = []
var current_fog_state = []

func _init(map_controller_object, terrain_node):
	map_controller = map_controller_object
	terrain = terrain_node
	root = map_controller_object.root

func init_node():
    fog_of_war = map_controller.get_node("fog_of_war")
    self.build_fog_pattern()

func build_fog_pattern():
	var sprite = 0
	var uniq_num
	var row_array
	var pattern_array
	for y in range(0, map_controller.MAP_MAX_Y):
		row_array = []
		pattern_array = []
		for x in range(0, map_controller.MAP_MAX_X):
			sprite = -1
			if terrain.get_cell(x,y) > -1:
				uniq_num = int(sin(x+y)+cos(x*y))
				if  uniq_num % 2 == 0:
					if uniq_num % 8 == 0:
						sprite = 0
					else:
						sprite = 1
				else:
					if uniq_num % 3 == 0:
						sprite = 2
					else:
						sprite = 3
			row_array.insert(x, sprite)
			pattern_array.insert(x, sprite)
		self.fog_pattern.insert(y, pattern_array)
		self.current_fog_state.insert(y, row_array)

func apply_fog():
	for x in range(0, map_controller.MAP_MAX_X):
		for y in range(0, map_controller.MAP_MAX_Y):
			if terrain.get_cell(x,y) > -1:
				fog_of_war.set_cell(x, y, self.current_fog_state[y][x])

func fill_fog():
	for x in range(0, map_controller.MAP_MAX_X):
		for y in range(0, map_controller.MAP_MAX_Y):
			if terrain.get_cell(x,y) > -1:
				self.current_fog_state[y][x] = self.fog_pattern[y][x]

func clear_fog_range(center, size):
	var x_min = center.x-size
	var x_max = center.x+size+1
	var y_min = center.y-size
	var y_max = center.y+size+1

	for x in range(x_min,x_max):
		for y in range(y_min,y_max):
			if x >= 0 && y >= 0:
				self.current_fog_state[y][x] = -1
	return

func clear():
    fog_of_war.clear()

func clear_cloud(x, y):
    fog_of_war.set_cell(x, y, -1)

func add_cloud(x, y, sprite):
    fog_of_war.set_cell(x, y, sprite)

func move_cloud(pos):
    fog_of_war.set_pos(pos)

func clear_fog():
	self.fill_fog()
	var units = root.get_tree().get_nodes_in_group("units")
	var buildings = root.get_tree().get_nodes_in_group("buildings")
	var current_player = 0

	if root.action_controller != null:
		current_player = root.action_controller.current_player

	for unit in units:
		# cpu vs cpu mode
		# show everything aka spectator mode
		if root.settings['cpu_0'] && root.settings['cpu_1']:
			self.clear_fog_range(unit.position_on_map,2)
		else:
			if unit.player == current_player:
				self.clear_fog_range(unit.position_on_map,2)

	for building in buildings:
		# cpu vs cpu mode
		# show everything aka visitor mode
		if root.settings['cpu_0'] && root.settings['cpu_1']:
			self.clear_fog_range(building.position_on_map,3)
		else:
			if building.player == current_player:
				self.clear_fog_range(building.position_on_map,3)
	self.apply_fog()