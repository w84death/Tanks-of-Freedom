var abstract_map
var grids = []
var tileObject = preload('tile_object.gd')

#rearrange
func init(abstract_map_new):
	abstract_map = abstract_map_new

func prepare_cost_maps(own_buildings, own_units, terrain):
	grids.clear()
	for unit_type in range(0,3):
		var cost_map = self._fillCostMap(abstract_map.tiles_cost_map[unit_type], own_units, own_buildings, terrain)
		grids.insert(unit_type, self._prepareGrid(cost_map))
	return grids

func _fillCostMap(cost_map, units, ownBuildings, terrain):
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

func _prepareGrid(cost_map):
	var grid = {}
	for x in range(cost_map.size()):
		for y in range(cost_map[x].size()):
			grid[Vector2(x,y)] = tileObject.new(cost_map[x][y])
	return grid
