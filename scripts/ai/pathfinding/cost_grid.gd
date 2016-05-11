var abstract_map
var tileObject = preload('tile_object.gd')
var grid = {}

#rearrange
func _init(abstract_map_new):
	abstract_map = abstract_map_new

func prepare_cost_grid():
	self.abstract_map.create_tile_type_map()

	self.__prepareGrid(abstract_map.cost_map)

func add_obstacles(obstacles):
	for position in obstacles:
		self.grid[position] = tileObject.new(tileObject.NON_WALKABLE)

func __prepareGrid(cost_map):
	for x in range(self.abstract_map.MAX_MAP_SIZE):
		for y in range(self.abstract_map.MAX_MAP_SIZE):
			self.grid[Vector2(x,y)] = tileObject.new(cost_map[x][y])
