var position_controller
var pathfinding
var abstract_map
var action_controller
const lookup_range = 8
var actions = {}
var current_player_ap = 0

const ACTION_ATTACK = 0
const ACTION_MOVE   = 1
const ACTION_CAPTURE = 2
const ACTION_SPAWN = 3

func gather_available_actions(player_ap):
	current_player_ap = player_ap
	actions = {}
	# refreshing unit and building data
	position_controller.refresh()
	print('DEBUG -------------------- ')
	self.gather_building_data()
	self.gather_unit_data()
	var action = self.execute_best_action()


func gather_unit_data():
	var units = position_controller.get_units_player_red()
	if units.size() == 0:
		return
	
	for pos in units:
		var unit = units[pos]
		var position = unit.get_pos_map()
		# this should be already map for use in pathfinding
		var cost_map = pathfinding.prepareCostMap(abstract_map.tiles_cost_map[unit.get_type()], units)

		var nearby_tiles = position_controller.get_nearby_tiles(position, lookup_range)
		var destinations = []

		destinations = position_controller.get_nearby_enemy_buldings(nearby_tiles) + position_controller.get_nearby_empty_buldings(nearby_tiles)
		for destination in destinations:
			self.add_action(unit, destination, cost_map)

		destinations = position_controller.get_nearby_enemies(nearby_tiles)
		for destination in destinations:
			self.add_action(unit, destination, cost_map)

func gather_building_data():
	var units = position_controller.get_units_player_red()
	var buildings = position_controller.get_buildings_player_red()
	for pos in buildings:
		var building = buildings[pos]
		var position = building.get_pos_map()
		var nearby_tiles = position_controller.get_nearby_tiles(position, lookup_range)
		var enemy_units = position_controller.get_nearby_enemies(nearby_tiles)
		
		self.add_building_action(building, enemy_units, units)


func add_action(unit, destination, cost_map):
	var path = pathfinding.pathSearch(unit.get_pos_map(), destination.get_pos_map())
	var action_type = ACTION_MOVE
	if path.size() == 0:
		return
		
	# jakies solidne WTF?
	if (unit.get_pos_map() == path[0]):
		path.remove(0)

	if path.size() > 0:
		# skip if this can be capture move and building cannot be captured
		var additional_modificator = 0;
		var unit_ap_cost = 0
		# verify action_type
		var next_tile = abstract_map.get_field(path[0])
		if (next_tile.object != null):
			if(next_tile.object.group == 'building' && unit.can_capture_building(next_tile.object)):
				action_type = ACTION_CAPTURE
			elif(next_tile.object.group == 'unit'): #todo sprawdzanie typu jednostki
				if (unit.can_attack()):
					action_type = ACTION_ATTACK
				else:
					return
		else:
			action_type = ACTION_MOVE
			unit_ap_cost = abstract_map.calculate_path_cost(unit, path)
			var last_tile = abstract_map.get_field(path[path.size() - 1])
			if (last_tile.object != null && last_tile.object.group == 'building' && !unit.can_capture_building(last_tile.object)):
				additional_modificator = -90

		var score = unit.estimate_action(action_type, path.size(), unit_ap_cost)
		score = score + additional_modificator
		
		print("DEBUG : ", self.get_action_name(action_type), " score: ", score, " ap: ", unit_ap_cost," pos: ",unit.get_pos_map()," path: ", path)
		actions[score] =  actionObject.new(unit, path, action_type)

func get_action_name(type):
	if type == ACTION_MOVE:
		return 'MOVE'
	elif (type == ACTION_CAPTURE):
		return 'CAPTURE'
	elif (type == ACTION_SPAWN):
		return 'SPAWN'
	else:
		return 'ATTACK'

func add_building_action(building, enemy_units_nearby, own_units):
	var action_type = ACTION_SPAWN
	var spawn_point = abstract_map.get_field(building.spawn_point)
	if (spawn_point.object == null && building.get_required_ap() <= current_player_ap):
		var score = building.estimate_action(action_type, enemy_units_nearby, own_units)
		print("DEBUG : ", self.get_action_name(action_type), " score: ", score, " ap: ", building.get_required_ap())
		actions[score] =  actionObject.new(building, null, action_type)

func execute_best_action():
	# last element of sorted keys
	var action = null
	var size = actions.size()
	if (size > 0):
		action = actions[self.get_max_key(actions.keys())]
		if action.type == ACTION_SPAWN:
			self.execute_spawn(action)
		elif action.type == ACTION_ATTACK:
			self.execute_attack(action)
		elif action.type == ACTION_CAPTURE:
			self.execute_capture(action)
		else:
			self.execute_move(action)

func get_max_key(keys):
	var max_key = 0
	for key in keys:
		if (key > max_key):
			max_key = key

	return max_key

func execute_spawn(action):
	action_controller.set_active_field(action.unit.get_pos_map())
	action_controller.spawn_unit_from_active_building()

func execute_move(action):
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

func execute_capture(action):
	var active_field = action_controller.set_active_field(action.unit.get_pos_map())
	var field = self.get_next_tile_from_action(action)
	if field:
	    action_controller.capture_building(active_field, field)

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
	var path
	var type

	func _init(unit, path, action_type):
		self.unit = unit
		self.path = path
		self.type = action_type

