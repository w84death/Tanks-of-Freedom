var abstract_map
var actions
var pathfinding
var positions
var action_builder
var elemental_trails_generated = false

func _init(abstract_map_object, actions_object, pathfinding_object, action_builder_object, positions_object):
	self.abstract_map = abstract_map_object
	self.actions = actions_object
	self.pathfinding = pathfinding_object
	self.action_builder = action_builder_object
	self.positions = positions_object

# TODO this method should be rewritten if no hq
func add_elemental_trails():
	#adding elemental trails for ant algoritmh
	if self.elemental_trails_generated:
		return
	var bunker_0 = self.positions.get_player_bunker_position(0)
	var bunker_1 = self.positions.get_player_bunker_position(1)

	self.abstract_map.add_trails([self.pathfinding.pathSearch(bunker_0, bunker_1, [])], 0)
	self.abstract_map.add_trails([self.pathfinding.pathSearch(bunker_1, bunker_0, [])], 1)

	var empty_building_positions = self.positions.buildings_player_none
	if empty_building_positions.size() > 0:
		for building_pos in empty_building_positions:
			self.abstract_map.add_trails([self.pathfinding.pathSearch(bunker_0, building_pos, [])], 0)
			self.abstract_map.add_trails([self.pathfinding.pathSearch(bunker_1, building_pos, [])], 1)

	self.elemental_trails_generated = true

func wander(unit, units):
	print('wandering!!')
	var position = unit.get_pos_map()
	var current_field = self.abstract_map.get_field(position)
	var available_directions = self.abstract_map.get_available_directions(unit, position)
	if available_directions.size() > 0:
		var new_position = current_field.next_tile_by_trail(available_directions)
		var score = 0
		if new_position != null && unit.get_ap() >= self.abstract_map.calculate_path_cost(unit, [position, new_position]):
			var action = self.action_builder.create(self.action_builder.ACTION_MOVE, unit, [new_position])
			var available_directions_size = available_directions.size()
			if (available_directions_size > 0):
				if (self.abstract_map.is_spawning_point(position)):
					score = 100
				else:
					score = available_directions.size() * 10 + randi() % units.size()

			self.actions.append_action(action, score)
