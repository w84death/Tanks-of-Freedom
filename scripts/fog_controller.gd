var fog_of_war
var map_controller
var terrain
var root

var fog_pattern = []
var current_fog_state = []

const VISIBILITY_RANGE = 2
const BUILDING_VISIBILITY_RANGE = 3

func _init(map_controller_object, terrain_node):
	map_controller = map_controller_object
	terrain = terrain_node
	root = map_controller_object.root

func init_node():
    fog_of_war = map_controller.get_node("fog_of_war")
    self.build_fog_pattern()

func is_fogged(x, y):
	if x < 0 or y < 0:
		return false
	return current_fog_state[y][x] > -1

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
	var new_x
	var new_y

	self.current_fog_state[center.y][center.x] = -1
	for tile_modifier in self.root.dependency_container.positions.precalculated_nearby_tiles[size]:
			new_x = center.x + tile_modifier.x
			new_y = center.y + tile_modifier.y
			if new_x >= 0 && new_y >= 0:
				self.current_fog_state[new_y][new_x] = -1
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
			self.clear_fog_range(unit.position_on_map, unit.visibility)
		else:
			if not (root.settings['cpu_0'] || root.settings['cpu_1']):
				if unit.player == current_player:
					self.clear_fog_range(unit.position_on_map, unit.visibility)
			else:
				if (unit.player == 0 && not root.settings['cpu_0']) || (unit.player == 1 && not root.settings['cpu_1']):
					self.clear_fog_range(unit.position_on_map, unit.visibility)

	for building in buildings:
		# cpu vs cpu mode
		# show everything aka visitor mode
		if root.settings['cpu_0'] && root.settings['cpu_1']:
			self.clear_fog_range(building.position_on_map,3)
		else:
			if not (root.settings['cpu_0'] || root.settings['cpu_1']):
				if building.player == current_player:
					self.clear_fog_range(building.position_on_map, BUILDING_VISIBILITY_RANGE)
			else:
				if (building.player == 0 && not root.settings['cpu_0']) || (building.player == 1 && not root.settings['cpu_1']):
					self.clear_fog_range(building.position_on_map, BUILDING_VISIBILITY_RANGE)
	self.apply_fog()