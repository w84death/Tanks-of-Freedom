extends "res://scripts/bag_aware.gd"

var fog_of_war
var map_controller
var terrain
var root

func _initialize():
	self.root = bag.root

var fog_pattern = {}
var current_fog_state = {}

func init_node(map_controller_object, terrain_node):
	self.map_controller = map_controller_object
	self.terrain = terrain_node
	self.fog_of_war = map_controller.get_node("fog_of_war")
	self.build_fog_pattern()

func is_fogged(tile):
	return current_fog_state[tile] > -1

func build_fog_pattern():
	var sprite = 0
	var uniq_num
	self.fog_pattern.clear()
	self.current_fog_state.clear()

	for y in range(0, self.map_controller.bag.abstract_map.MAP_MAX_Y):
		for x in range(0, self.map_controller.bag.abstract_map.MAP_MAX_X):
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


			self.fog_pattern[Vector2(x, y)] = sprite
			self.current_fog_state[Vector2(x, y)] = sprite

func apply_fog():
	for tile in map_controller.used_tiles_list:
		fog_of_war.set_cell(tile.x, tile.y, self.current_fog_state[tile])

func fill_fog():
	for tile in map_controller.used_tiles_list:
		self.current_fog_state[tile] = self.fog_pattern[tile]

func clear_fog_range(center, size):
	var tile = center
	self.current_fog_state[tile] = -1
	for mod in self.bag.positions.precalculated_nearby_tiles[size]:
		tile = center + mod
		if tile.x >=0 && tile.y >=0:
			self.current_fog_state[tile] = -1
	return

func clear():
	fog_of_war.clear()

func clear_cloud(x, y):
	fog_of_war.set_cell(x, y, -1)

func add_cloud(x, y, sprite):
	fog_of_war.set_cell(x, y, sprite)

func move_cloud(pos):
	fog_of_war.set_position(pos)

func toggle_fog():
	if self.fog_of_war.is_visible():
		self.fog_of_war.hide()
	else:
		self.fog_of_war.show()

func hide_fog():
	self.fog_of_war.hide()

func show_fog():
	self.fog_of_war.show()

func clear_fog():
	self.fill_fog()
	var current_player = 0
	var positions = []
	if root.action_controller != null:
		current_player = root.action_controller.current_player

	self.bag.positions.refresh_units()
	self.bag.positions.refresh_buildings()
	var units = self.__get_units_to_unhide(current_player)
	for positionVAR in units:
		#taking visibility parameter from unit
		self.__remove_fog(positionVAR, units[positionVAR].visibility)
	for positionVAR in self.__get_buildings_to_unhide(current_player):
		self.__remove_fog(positionVAR, 3)

	self.apply_fog()

func __get_units_to_unhide(player):
	if root.settings['cpu_0'] && root.settings['cpu_1']:
		return self.bag.positions.all_units
	else:
		if is_cpu(player):
			return self.bag.positions.get_player_units((player + 1) % 2)
		return self.bag.positions.get_player_units(player)

func __get_buildings_to_unhide(player):
	if root.settings['cpu_0'] && root.settings['cpu_1']:
		return self.bag.positions.all_buildings
	else:
		if self.is_cpu(player):
			return self.bag.positions.get_player_buildings((player + 1) % 2)
		return self.bag.positions.get_player_buildings(player)

func __remove_fog(position_on_map, view_range):
	self.clear_fog_range(position_on_map, view_range)

func is_cpu(player):
	if root.settings['cpu_' + str(player)]:
		return true

	return false

