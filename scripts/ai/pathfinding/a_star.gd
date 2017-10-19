extends "res://scripts/bag_aware.gd"

var grid = {} #basic grid
var map_grid = {} #grid with obstacles and stuff

var astar = AStar.new()

var obstacles = []
var new_obstacles = []
var passable_field_count = 0

const NEIGHBORS_KEY = 0
const POSITION_KEY = 1

func _initialize():
    self.prepare_grid()

func path_search(start, goal):
    var path = []
    for id in self.astar.get_id_path(self.pos_2_point_id(start), self.pos_2_point_id(goal)):
        path.push_back(self.point_id_2_pos(id))

    return path

func rebuild_current_grid():
    self.prepare_map_grid(self.bag.abstract_map)

func prepare_map_grid(abstract_map):
    var field = null
    var pos = null
    var passable = false
    self.passable_field_count = 0
    for id in self.grid:
        field = abstract_map.get_field(self.point_id_2_pos(id))
        passable = !(field.has_terrain() or field.is_empty() or field.has_building())
        self.map_grid[id] = {
            "passable"  : passable,
        }
        if passable:
            self.passable_field_count = self.passable_field_count + 1

    self.__reset_grid()
    self.connect_passable_tiles()

func prepare_grid():
    var id = 0
    for x in range(self.bag.abstract_map.MAX_MAP_SIZE):
        for y in range(self.bag.abstract_map.MAX_MAP_SIZE):
            id = self.get_point_id(x, y)
            self.grid[id] = {
                self.NEIGHBORS_KEY : self.__prepare_neighbors(x, y),
                self.POSITION_KEY  : Vector2(x, y),
            }
            self.astar.add_point(id, Vector3(x, y, 0))

func set_obstacles(obstacle_positions):
    for position in obstacle_positions:
        self.new_obstacles.push_back(self.get_point_id(position.x, position.y))

    for id in self.bag.helpers.array_diff(self.obstacles, self.new_obstacles):
        self.connect_point(id)
    for id in self.bag.helpers.array_diff(self.new_obstacles, self.obstacles):
        self.disconnect_point(id)

    self.obstacles = Array(self.new_obstacles)
    self.new_obstacles = []

func get_distance(start, end):
    return abs(start.x - end.x) + abs(start.y - end.y)

func connect_passable_tiles():
    for tile_id in map_grid:
        if self.map_grid[tile_id].passable:
            self.connect_point(tile_id)

func connect_all():
    for tile_id in map_grid:
        self.connect_point(tile_id)

func connect_point(tile_id):
    for id in self.get_adjacement_tile_ids(tile_id):
        if not astar.are_points_connected(tile_id, id):
            if self.map_grid[id].passable:
                astar.connect_points(tile_id, id)

func disconnect_all():
    for tile_id in map_grid:
        disconnect_point(tile_id)

func disconnect_point(tile_id):
    for id in get_adjacement_tile_ids(tile_id):
        if astar.are_points_connected(tile_id, id):
            astar.disconnect_points(tile_id, id)

func get_point_id(x, y):
    return x * 1000 + y

func pos_2_point_id(pos):
    return get_point_id(pos.x, pos.y)

func point_id_2_pos(id):
    return self.grid[id][POSITION_KEY]

func get_adjacement_tile_ids(tile_id):
    var ids = IntArray([])
    var field
    if self.grid.has(tile_id):
        var neighbors = self.grid[tile_id][self.NEIGHBORS_KEY]
        for neighbor in neighbors.values():
            field = self.bag.abstract_map.get_field(neighbor)
            if field != null and !field.is_empty():
                ids.push_back(self.get_point_id(neighbor.x, neighbor.y))

    return ids

func refresh_grid():
    print('refresh grid')

func reset_obstacles():
    self.obstacles.clear()
    self.new_obstacles.clear()

func __reset_grid():
    self.disconnect_all()
    self.reset_obstacles()

func __validate_tile(pos): # TODO - move to abstract map or tile or smth
    if pos.x < 0 or pos.x > self.bag.abstract_map.MAX_MAP_SIZE:
        return false
    if pos.y < 0 or pos.y > self.bag.abstract_map.MAX_MAP_SIZE:
        return false
    var tile_id = self.pos_2_point_id(pos)

    if self.map_grid.has(tile_id) and self.map_grid[tile_id].passable == false:
        return false

    return true

func __prepare_neighbors(x, y):
    var neighbors = {
        "u" : Vector2(x  ,y-1),
        "r" : Vector2(x+1,y  ),
        "d" : Vector2(x  ,y+1),
        "l" : Vector2(x-1,y  ),
    }

    for direction in neighbors:
        if !self.__validate_tile(neighbors[direction]):
            neighbors.erase(direction)

    return neighbors


