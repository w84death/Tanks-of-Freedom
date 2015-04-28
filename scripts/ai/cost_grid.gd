var abstract_map
var grids = []
var tileObject = preload('res://scripts/ai/pathfinding/tile_object.gd')

#rearrange
func _init(abstract_map_new):
	abstract_map = abstract_map_new

func prepare_cost_maps(own_buildings, own_units, terrain):
	grids.clear()
	for unit_type in range(0,3):
		var cost_map = self.__fillCostMap(abstract_map.tiles_cost_map[unit_type], own_units, own_buildings, terrain)
		grids.insert(unit_type, self.__prepareGrid(cost_map))
	return grids

func __fillCostMap(cost_map, units, ownBuildings, terrain):
	for pos in units:
		var unit_pos = units[pos].get_pos_map()
		cost_map[unit_pos.x][unit_pos.y] = tileObject.NON_WALKABLE

	for pos in ownBuildings:
		var unit_pos = ownBuildings[pos].get_pos_map()
		cost_map[unit_pos.x][unit_pos.y] = tileObject.NON_WALKABLE

	for pos in terrain:
		var unit_pos = terrain[pos].get_pos_map()
		cost_map[unit_pos.x][unit_pos.y] = tileObject.NON_WALKABLE

	return cost_map

func __prepareGrid(cost_map):
	var grid = {}
	for x in range(cost_map.size()):
		for y in range(cost_map[x].size()):
			grid[Vector2(x,y)] = tileObject.new(cost_map[x][y])
	return grid
