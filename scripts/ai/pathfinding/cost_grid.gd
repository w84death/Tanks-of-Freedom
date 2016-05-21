var abstract_map
var tile_object = preload('tile_object.gd')
var grid = {}

#rearrange
func _init(abstract_map_new):
    abstract_map = abstract_map_new

func prepare_cost_grid():
    self.abstract_map.create_tile_type_map()

    self.__prepareGrid(abstract_map.cost_map)

func refresh_cost_grid():
    for pos in self.grid:
        self.grid[pos] = tile_object.new(abstract_map.cost_map[pos.x][pos.y])

func add_obstacles(obstacles):
    for position in obstacles:
        self.grid[position].set_not_walkable()

func __prepareGrid(cost_map):
    for x in range(self.abstract_map.MAX_MAP_SIZE):
        for y in range(self.abstract_map.MAX_MAP_SIZE):
            self.grid[Vector2(x,y)] = tile_object.new(cost_map[x][y], true)


