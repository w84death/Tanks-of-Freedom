var position_controller
var pathfinding
var abstract_map
var action_controller
const CLOSE_RANGE = 3
const LOOKUP_RANGE = 10
var actions = {}
var current_player_ap = 0
var current_player

const SPAWN_LIMIT = 25
const DEBUG = false
var terrain
var units
var buildings
var enemy_bunker

var actionBuilder
var cost_grid

var behaviour_normal
var behaviour_destroyer
var behaviour_explorer
var behaviours = []
var elemental_trails_generated = false

var player_behaviours

func _init(controller, astar_pathfinding, map, action_controller_object):
	position_controller = controller
	pathfinding = astar_pathfinding
	abstract_map = map
	action_controller = action_controller_object
	cost_grid = preload('pathfinding/cost_grid.gd').new(abstract_map)
	actionBuilder = preload('actions/action_builder.gd').new(action_controller, abstract_map, position_controller)

	behaviour_normal = preload('behaviours/normal.gd').new()
	behaviour_destroyer = preload('behaviours/destroyer.gd').new()
	behaviour_explorer = preload('behaviours/explorer.gd').new()
	behaviours = [behaviour_normal, behaviour_explorer, behaviour_destroyer]

	player_behaviours = [behaviour_normal, behaviour_normal]

# TODO move this to separate file - this method should be rewritten if no hq
func add_elemental_trails():
	#adding elemental trails for ant algoritmh
	if elemental_trails_generated:
		return
	var bunker_0 = position_controller.get_player_bunker_position(0)
	var bunker_1 = position_controller.get_player_bunker_position(1)

	abstract_map.add_trails([pathfinding.pathSearch(bunker_0, bunker_1, [])], 0)
	abstract_map.add_trails([pathfinding.pathSearch(bunker_1, bunker_0, [])], 1)

	var empty_building_positions = position_controller.buildings_player_none
	if empty_building_positions.size() > 0:
		for building_pos in empty_building_positions:
			abstract_map.add_trails([pathfinding.pathSearch(bunker_0, building_pos, [])], 0)
			abstract_map.add_trails([pathfinding.pathSearch(bunker_1, building_pos, [])], 1)

	elemental_trails_generated = true

func select_behaviour_type(player):
	player_behaviours[player] = behaviours[floor(rand_range(0, behaviours.size()))]
	#print('SELECTED BEHAVIOUR FOR PLAYER: ', player, ' IS ', rand)

func gather_available_actions(player_ap):
	current_player = action_controller.current_player
	current_player_ap = player_ap
	actions = {}
	# refreshing unit and building data
	position_controller.refresh_units()
	#position_controller.refresh_buildings()
	if DEBUG:
		print('DEBUG -------------------- ')
	buildings = position_controller.get_player_buildings(current_player)
	units     = position_controller.get_player_units(current_player)
	terrain   = position_controller.get_terrain_obstacles()

	self.__gather_building_data(buildings, units)
	self.__gather_unit_data(buildings, units, terrain)

	return self.__execute_best_action()

func __gather_unit_data(own_buildings, own_units, terrain):
	if own_units.size() == 0:
		return

	var cost_grids = cost_grid.prepare_cost_maps(own_buildings, own_units, terrain)

	#TODO move it somewhere!!!
	pathfinding.set_cost_grid(cost_grids[2])
	add_elemental_trails()

	for pos in own_units:
		var unit = own_units[pos]
		if unit.get_ap() > 2:
			var position = unit.get_pos_map()

			var destinations = []
			destinations = self.__gather_unit_destinations(position, current_player)
			destinations = destinations + __gather_buildings_destinations(position, current_player)
			if destinations.size() == 0:
				if current_player_ap > 3:
					self.__wander(unit)
			else:
				#TODO - calculate data in units groups
				pathfinding.set_cost_grid(cost_grids[unit.get_type()])
				for destination in destinations:
					self.__add_action(unit, destination, own_units)

func __wander(unit):
	var position = unit.get_pos_map()
	print('wandering!!')
	var current_field = abstract_map.get_field(position)
	var available_directions = abstract_map.get_available_directions(unit, position)
	if available_directions.size() > 0:
		var new_position = current_field.next_tile_by_trail(available_directions)
		var score = 0
		if new_position != null:
			if unit.get_ap() >= abstract_map.calculate_path_cost(unit, [position, new_position]):
				var action = actionBuilder.create(actionBuilder.ACTION_MOVE, unit, [new_position])
				var available_directions_size = available_directions.size()
				if (available_directions_size > 0):
					if (abstract_map.is_spawning_point(position)):
						score = 100
					else:
						score = available_directions.size() * 10 + randi() % units.size()

				self.__append_action(action, score)

func __gather_unit_destinations(position, current_player, tiles_ranges=position_controller.tiles_lookup_ranges):
	var destinations = []
	for lookup_range in tiles_ranges:
		var nearby_tiles = position_controller.get_nearby_tiles(position, lookup_range)
		destinations = destinations + position_controller.get_nearby_enemies(nearby_tiles, current_player)

		if destinations.size() > 0:
			#print('RANGE OF UNIT LOOKUP', lookup_range)
			return destinations
	
	return destinations

#TODO this method will be rewritten to use building cache
func __gather_buildings_destinations(position, current_player):
	var destinations = []
	for lookup_range in position_controller.tiles_lookup_ranges:
		var nearby_tiles = position_controller.get_nearby_tiles(position, lookup_range)
		destinations = position_controller.get_nearby_enemy_buldings(nearby_tiles, current_player)
		destinations = destinations + position_controller.get_nearby_empty_buldings(nearby_tiles)

		if destinations.size() > 0:
			#print('RANGE OF BUILDING LOOKUP', lookup_range)
			return destinations

	return destinations

func __gather_building_data(own_buildings, own_units):
	if own_units.size() >= SPAWN_LIMIT:
		return
	#var buildings = position_controller.get_player_buildings(current_player)
	for pos in own_buildings:
		var building = own_buildings[pos]

		if (building.type == 4): # skip tower
			continue

		var enemy_units = self.__gather_unit_destinations(building.get_pos_map(), current_player, position_controller.tiles_building_lookup_ranges)
		self.__add_building_action(building, enemy_units, own_units)


func __add_action(unit, destination, own_units):
	var path = pathfinding.pathSearch(unit.get_pos_map(), destination.get_pos_map(), own_units) #todo move cache temporary invalidation before loop

	var action_type = actionBuilder.ACTION_MOVE
	var hiccup = false
	if path.size() == 0:
		return

	# jakies solidne WTF?
	if (unit.get_pos_map() == path[0]):
		path.remove(0)

	if path.size() > 0:
		# skip if this can be capture move and building cannot be captured
		var unit_ap_cost = 0
		var tile_ap = 0
		# verify action_type
		var next_tile = abstract_map.get_field(path[0])

		if (next_tile.object != null):
			if(next_tile.object.group == 'building'):
				if unit.can_capture_building(next_tile.object):
					action_type = actionBuilder.ACTION_CAPTURE
				else:
					return # if cannot capture he canot move
			elif next_tile.object.group == 'unit':
				if unit.can_attack_unit_type(next_tile.object) && unit.can_attack():
					action_type = actionBuilder.ACTION_ATTACK
				else:
					return
			# elif next_tile.object.group == "terrain":
			# 	return # no tresspassing
		else:
			var from = action_controller.abstract_map.get_field(unit.get_pos_map())
			# todo - check why this still counts as action
			if not from.object:
				return

			var to = action_controller.abstract_map.get_field(path[0])
			if not action_controller.movement_controller.can_move(from, to):
				return

			action_type = actionBuilder.ACTION_MOVE
			unit_ap_cost = abstract_map.calculate_path_cost(unit, path)
			var last_tile = abstract_map.get_field(path[path.size() - 1])
			if (last_tile.object != null):
				if (last_tile.object.group == 'building'):
					if (unit.can_capture_building(last_tile.object)):
						action_type = actionBuilder.ACTION_MOVE_TO_CAPTURE

				elif(last_tile.object.group == 'unit'):
					if (unit.can_attack_unit_type(last_tile.object)):
						action_type = actionBuilder.ACTION_MOVE_TO_ATTACK

			# checking for movement hiccup (only for movement)
			hiccup = unit.check_hiccup(path[0])


		var score = unit.estimate_action(action_type, path.size(), unit_ap_cost, hiccup, player_behaviours)
		var action = actionBuilder.create(action_type, unit, path)
		self.__append_action(action, score)
		if DEBUG:
			print("DEBUG : ", action.get_action_name(), " score: ", score, " ap: ", unit_ap_cost," pos: ",unit.get_pos_map()," path: ", path)

func __add_building_action(building, enemy_units_nearby, own_units):

	var action_type = actionBuilder.ACTION_SPAWN
	var spawn_point = abstract_map.get_field(building.spawn_point)
	if (spawn_point.object == null && building.get_required_ap() <= current_player_ap):
		var score = building.estimate_action(action_type, enemy_units_nearby, own_units)

		var action = actionBuilder.create(action_type, building, null)
		self.__append_action(action, score)
		if DEBUG:
			print("DEBUG : ", action.get_action_name(), " score: ", score, " ap: ", building.get_required_ap())


func __append_action(action, score):
	if actions.has(score):
		score = score + floor(randf() * 20)

	actions[score] = action

func __execute_best_action():
	var size = actions.size()
	if (size > 0):
		var action = actions[self.__get_max_key(actions.keys())]
		return action.execute()

	return false

func __get_max_key(keys):
	var max_key = -999
	for key in keys:
		if (key > max_key):
			max_key = key

	return max_key


