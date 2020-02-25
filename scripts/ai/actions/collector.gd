extends "res://scripts/bag_aware.gd"

var unit_brains = {
	"soldier" : load("res://scripts/ai/actions/brains/soldier_brain.gd").new(),
	"tank" : load("res://scripts/ai/actions/brains/tank_brain.gd").new(),
	"heli" : load("res://scripts/ai/actions/brains/heli_brain.gd").new(),
}

var building_brains = {
	"hq" : load("res://scripts/ai/actions/brains/hq_brain.gd").new(),
	"barracks" : load("res://scripts/ai/actions/brains/barracks_brain.gd").new(),
	"factory" : load("res://scripts/ai/actions/brains/factory_brain.gd").new(),
	"airport" : load("res://scripts/ai/actions/brains/airport_brain.gd").new(),
	"gsm tower" : load("res://scripts/ai/actions/brains/tower_brain.gd").new(),
}


func _initialize():
	for key in self.unit_brains:
		self.unit_brains[key]._init_bag(self.bag)
	for key in self.building_brains:
		self.building_brains[key]._init_bag(self.bag)


func get_available_actions(current_player):
	var building_actions = self._collect_building_actions(current_player)
	var unit_actions = self._collect_unit_actions(current_player)

	var combined_actions = []

	for action in building_actions:
		combined_actions.append(action)

	for action in unit_actions:
		combined_actions.append(action)

	return combined_actions


func _collect_building_actions(current_player):
	var buildings = self.bag.positions.get_player_buildings(current_player)
	var enemies = self.bag.positions.get_enemy_units(current_player)
	var units = self.bag.positions.get_player_units(current_player)

	var brain
	var building
	var current_building_actions
	var collected_actions = []

	for building_position in buildings:
		building = buildings[building_position]
		brain = self._get_building_brain(building)
		current_building_actions = brain.get_actions(building, enemies, units)

		for action in current_building_actions:
			collected_actions.append(action)

	return collected_actions


func _collect_unit_actions(current_player):
	var units = self.bag.positions.get_player_units(current_player)
	var enemies = self.bag.positions.get_enemy_units(current_player)
	var buildings = self.bag.positions.get_not_owned_buildings(current_player)
	var own_buildings = self.bag.positions.get_player_buildings(current_player)

	var brain
	var unit
	var current_unit_actions
	var collected_actions = []

	for unit_position in units:
		unit = units[unit_position]
		brain = self._get_unit_brain(unit)
		current_unit_actions = brain.get_actions(unit, enemies, buildings, units, own_buildings)

		for action in current_unit_actions:
			collected_actions.append(action)

	return collected_actions


func _get_building_brain(building):
	return self.building_brains[building.get_building_name().to_lower()]

func _get_unit_brain(unit):
	return self.unit_brains[unit.type_name.to_lower()]

