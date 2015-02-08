var position_controller
var pathfinding
var abstract_map
var action_controller
const lookup_range = 4
var actions = {}
var current_player_ap = 0

const ACTION_ATTACK = 0
const ACTION_MOVE   = 1
const ACTION_CAPTURE = 2
const ACTION_SPAWN = 3

func gather_available_actions(player_ap):
	current_player_ap = player_ap
	self.gather_unit_data()
	self.gather_building_data()
	var action = self.execute_best_action()

func gather_unit_data():
	var units = position_controller.get_units_player_red()
	if units.size() == 0:
		return
	
	for pos in units:
		var unit = units[pos]
		var position = unit.get_pos_map()
		# this should be already map for use in pathfinding
		var cost_map = pathfinding.prepareCostMap(abstract_map.tiles_cost_map[unit.get_type()])

		var nearby_tiles = position_controller.get_nearby_tiles(position, lookup_range)
		var destinations = []
		destinations = position_controller.get_nearby_enemy_buldings(nearby_tiles)
		for destination in destinations:
			self.add_action(unit, position, destination, cost_map, ACTION_CAPTURE)

		destinations = position_controller.get_nearby_empty_buldings(nearby_tiles)
		for destination in destinations:
			self.add_action(unit, position, destination, cost_map, ACTION_CAPTURE)

		destinations = position_controller.get_nearby_enemies(nearby_tiles)
		for destination in destinations:
			self.add_action(unit, position, destination, cost_map, ACTION_ATTACK)

func gather_building_data():
	var units = position_controller.get_units_player_red()
	var buildings = position_controller.get_buildings_player_red()
	for pos in buildings:
		var building = buildings[pos]
		var position = building.get_pos_map()
		var nearby_tiles = position_controller.get_nearby_tiles(position, lookup_range)
		var enemy_units = position_controller.get_nearby_enemies(nearby_tiles)

		self.add_building_action(building, enemy_units, units)


func add_action(unit, position, destination, cost_map, action_type):
	var path = pathfinding.pathSearch(cost_map, position, destination.get_pos_map())
	if path.size() > 0:
		var unit_ap_cost = abstract_map.calculate_path_cost(unit, path)
		# verify action_type

		var can_be_finished
		if (unit_ap_cost <= unit.get_stats().ap): #todo sprawdzanie czy liczba rozkazów jest si
			can_be_finished = true
		else :
			can_be_finished = false
			action_type = ACTION_MOVE # because it will not reach destination
		# jakis dziwny algorytm skorowania todo dostosowac i sprawdzic sens
		var score = unit.estimate_action(action_type, can_be_finished, destination, path.size(), unit_ap_cost)
		actions[score] =  actionObject.new(unit, destination, path, action_type)


func add_building_action(unit, enemy_units_nearby, own_units):
	var action_type = ACTION_SPAWN
	if (unit.get_required_ap() >= current_player_ap):
		var score = unit.estimate_action(action_type, enemy_units_nearby, own_units)
		#actions[score] =  actionObject.new(unit, null, null, action_type)

func execute_best_action():
	# last element of sorted keys
	var action = null
	var size = actions.size()
	if (size > 0):
		action = actions[actions.keys()[actions.size() - 1]]
		if action.type == ACTION_SPAWN:
			self.execute_spawn(action)
		elif action.type == ACTION_ATTACK:
			self.execute_attack(action)
		else:
			self.execute_move(action)

func execute_spawn(action):
	print('spawn')
	action_controller.set_active_field(action.unit.get_pos_map())
	action_controller.spawn_unit_from_active_building()

func execute_move(action):
	print('move')
	var active_field = action_controller.set_active_field(action.unit.get_pos_map())
	var field = self.get_next_tile_from_action(action)
	if field:
		action_controller.move_unit(active_field, field)

func execute_attack(action):
	print('attack')
	var active_field = action_controller.set_active_field(action.unit.get_pos_map())
	var field = self.get_next_tile_from_action(action)
	if field:
		action_controller.handle_battle(active_field, field)

func get_next_tile_from_action(action):
	var path = action.path
	if path.size() == 0:
		return null
		
	return abstract_map.get_field(path[0])

func init(controller, astar_pathfinding, map, action_controller_object):
	position_controller = controller
	pathfinding = astar_pathfinding
	abstract_map = map
	action_controller = action_controller_object

class actionObject:
	var unit
	var destination
	var path
	var type

	func _init(unit, destination, path, action_type):
		self.unit = unit
		self.destination = destination
		self.path = path
		self.type = action_type

