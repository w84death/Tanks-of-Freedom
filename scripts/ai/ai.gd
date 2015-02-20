var position_controller
var pathfinding
var abstract_map
var action_controller
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

func _init(controller, astar_pathfinding, map, action_controller_object):
	position_controller = controller
	pathfinding = astar_pathfinding
	abstract_map = map
	action_controller = action_controller_object
	cost_grid = preload('cost_grid.gd').new(abstract_map)
	actionBuilder = preload('actions/action_builder.gd').new(action_controller, abstract_map)

func gather_available_actions(player_ap):
	current_player = action_controller.current_player
	current_player_ap = player_ap
	actions = {}
	# refreshing unit and building data
	position_controller.refresh()
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

	for pos in own_units:
		var unit = own_units[pos]
		if unit.get_ap() < 2:
			return
		var position = unit.get_pos_map()

		var nearby_tiles = position_controller.get_nearby_tiles(position, LOOKUP_RANGE)
		var destinations = []

		destinations = position_controller.get_nearby_enemy_buldings(nearby_tiles, current_player)
		destinations = destinations + position_controller.get_nearby_empty_buldings(nearby_tiles)
		destinations = destinations + position_controller.get_nearby_enemies(nearby_tiles, current_player)
		pathfinding.set_cost_grid(cost_grids[unit.get_type()])
		for destination in destinations:
			self.__add_action(unit, destination)

func __gather_building_data(own_buildings, own_units):
	if own_units.size() >= SPAWN_LIMIT:
		return
	#var buildings = position_controller.get_player_buildings(current_player)
	for pos in own_buildings:
		var building = own_buildings[pos]

		var nearby_tiles = position_controller.get_nearby_tiles(building.get_pos_map(), LOOKUP_RANGE)
		var enemy_units = position_controller.get_nearby_enemies(nearby_tiles, current_player)

		self.__add_building_action(building, enemy_units, own_units)

func __add_action(unit, destination):
	var path = pathfinding.pathSearch(unit.get_pos_map(), destination.get_pos_map())
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


		var score = unit.estimate_action(action_type, path.size(), unit_ap_cost, hiccup)
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


