var abstract_map
var tileObject = preload('tile_object.gd')

#rearrange
func _init(abstract_map_new):
	abstract_map = abstract_map_new

func prepare_cost_maps(own_buildings, own_units):
	var cost_map = self.__fillCostMap(abstract_map.cost_map, own_units, own_buildings)
	return self.__prepareGrid(cost_map)

func __fillCostMap(cost_map, units, ownBuildings):
	for pos in units:
		var unit_pos = units[pos].get_pos_map()
		cost_map[unit_pos.x][unit_pos.y] = tileObject.NON_WALKABLE

	for pos in ownBuildings:
		var unit_pos = ownBuildings[pos].get_pos_map()
		cost_map[unit_pos.x][unit_pos.y] = tileObject.NON_WALKABLE

	return cost_map

func __prepareGrid(cost_map):
	var grid = {}
	for x in range(32):
		for y in range(32):
			grid[Vector2(x,y)] = tileObject.new(cost_map[x][y])
	return grid
