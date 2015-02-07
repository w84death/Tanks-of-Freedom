var position_controller
var pathfinding
const lookup_range = 4
var actions = []

func gather_available_actions():
	print('gathering moves')
	self.gather_unit_data()

func gather_unit_data():
	var units = position_controller.get_units_player_red()
	if units.size() == 0:
		return
	
	for pos in units:
		var unit = units[pos]
		var position = unit.get_pos_map()

		var nearby_tiles = position_controller.get_nearby_tiles(position, lookup_range)
		var destinations = []
		destinations = position_controller.get_nearby_enemy_buldings(nearby_tiles)
		for destination in destinations:
			self.add_action(unit, destination)

		destinations = position_controller.get_nearby_empty_buldings(nearby_tiles)
		for destination in destinations:
			self.add_action(unit, destination)

		destinations = position_controller.get_nearby_enemies(nearby_tiles)
		for destination in destinations:
			self.add_action(unit, destination)

func add_action(unit, destination):
	actions.append(destination);
	print('+')
	print(destination)


func generate_action_assignments():
	print('sorting actions')

func sort_assignments():
	print('sorting actions')

func execute_assignments():
	print('execute')

func init(controller, astar_pathfinding):
	position_controller = controller
	pathfinding = astar_pathfinding

