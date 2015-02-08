var position_controller
var pathfinding
var abstract_map
const lookup_range = 4
var actions = {}
var current_player_ap = 0

const action_attack = 0
const action_move   = 1
const action_capture = 2
const action_spawn = 3

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
			self.add_action(unit, position, destination, cost_map, action_capture)

		destinations = position_controller.get_nearby_empty_buldings(nearby_tiles)
		for destination in destinations:
			self.add_action(unit, position, destination, cost_map, action_capture)

		destinations = position_controller.get_nearby_enemies(nearby_tiles)
		for destination in destinations:
			self.add_action(unit, position, destination, cost_map, action_attack)

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
			action_type = action_move # because it will not reach destination
		# jakis dziwny algorytm skorowania todo dostosowac i sprawdzic sens
		var score = unit.estimate_action(action_type, can_be_finished, destination, path.size(), unit_ap_cost)
		actions[score] =  actionObject.new(unit, destination, path, action_type)


func add_building_action(unit, enemy_units_nearby, own_units):
	var action_type = action_spawn
	if (unit.get_required_ap() >= current_player_ap):
		var score = unit.estimate_action(action_type, enemy_units_nearby, own_units)
		actions[score] =  actionObject.new(unit, null, null, action_type)

func execute_best_action():
	# last element of sorted keys
	var action = null
	var size = actions.size()
	if (size > 0):
		action = actions.keys()[actions.size() - 1]
		#print('executiong action')


func init(controller, astar_pathfinding, map):
	position_controller = controller
	pathfinding = astar_pathfinding
	abstract_map = map

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

