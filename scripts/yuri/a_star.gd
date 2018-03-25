extends "res://scripts/bag_aware.gd"

var grid = {} #basic grid
var map_grid = {} #grid with obstacles and stuff

var astar = AStar.new()

var obstacles = []
var new_obstacles = []
var passable_field_count = 0

const NEIGHBOURS_KEY = "neighbours"
const POSITION_KEY = "position"

const DEFAULT_WEIGHT = 1.0
const TEMP_IMPASSABLE_WEIGHT = 999.0

func _initialize():
    self._prepare_grid()

func path_search(start, goal):
    var path_translated = []
    var value = 0

    var path_found = self.astar.get_id_path(self._pos_2_point_id(start), self._pos_2_point_id(goal))
    for id in path_found:
        path_translated.push_back(self._point_id_2_pos(id))
        value = value + self.astar.get_point_weight_scale(id)

    return {
        "path" : path_translated,
        "value" : value
    }

func rebuild_current_grid():
    self.prepare_map_grid(self.bag.abstract_map)

func prepare_map_grid(abstract_map):
    var field = null
    var pos = null
    var passable = false
    self.passable_field_count = 0
    for id in self.grid:
        field = abstract_map.get_field(self.point_id_2_pos(id))
        passable = !(field.has_terrain() or field.is_empty())
        self.map_grid[id] = {
            "passable"  : passable,
        }
        if passable:
            self.passable_field_count = self.passable_field_count + 1

    self._reset_grid()
    self._connect_passable_tiles()

func set_obstacles(obstacle_positions):
    self.set_obstacles_old(obstacle_positions)
    return

    for position in obstacle_positions:
        self.new_obstacles.push_back(self._get_point_id(position.x, position.y))

    for id in self.bag.helpers.array_diff(self.obstacles, self.new_obstacles):
        self._remove_obstacle(id)
    for id in self.bag.helpers.array_diff(self.new_obstacles, self.obstacles):
        self._add_obstacle(id)

    self.obstacles = Array(self.new_obstacles)
    self.new_obstacles = []

func set_obstacles_old(obstacle_positions):
    for position in obstacle_positions:
        self.new_obstacles.push_back(self._get_point_id(position.x, position.y))

    for id in self.bag.helpers.array_diff(self.obstacles, self.new_obstacles):
        self._connect_point(id)
    for id in self.bag.helpers.array_diff(self.new_obstacles, self.obstacles):
        self._disconnect_point(id)

    self.obstacles = Array(self.new_obstacles)
    self.new_obstacles = []

func remove_obstacles():
    self.set_obstacles([])

func get_distance(start, end):
    return abs(start.x - end.x) + abs(start.y - end.y)

func add_obstacle(obstacle_position):
    self._add_obstacle(self._pos_2_point_id(obstacle_position))

func _add_obstacle(tile_id):
    self.astar.set_point_weight_scale(tile_id, self.TEMP_IMPASSABLE_WEIGHT)

func remove_obstacle(obstacle_position):
    self._remove_obstacle(self._pos_2_point_id(obstacle_position))

func _remove_obstacle(tile_id):
    self.astar.set_point_weight_scale(tile_id, self.DEFAULT_WEIGHT)

func _connect_passable_tiles():
    for tile_id in map_grid:
        if self.map_grid[tile_id].passable:
            self._connect_point(tile_id)


func _prepare_grid():
    var id = 0
    for x in range(self.bag.abstract_map.MAX_MAP_SIZE):
        for y in range(self.bag.abstract_map.MAX_MAP_SIZE):
            id = self._get_point_id(x, y)
            self.grid[id] = {
                self.NEIGHBOURS_KEY : self._prepare_neighbours(x, y),
                self.POSITION_KEY  : Vector2(x, y),
            }
            self.astar.add_point(id, Vector3(x, y, 0))

func _connect_point(tile_id):
    for id in self._get_adjacent_tile_ids(tile_id):
        if not astar.are_points_connected(tile_id, id):
            if self.map_grid[id].passable:
                astar.connect_points(tile_id, id)

func _disconnect_all():
    for tile_id in map_grid:
        self._disconnect_point(tile_id)

func _disconnect_point(tile_id):
    for id in self._get_adjacent_tile_ids(tile_id):
        if astar.are_points_connected(tile_id, id):
            astar.disconnect_points(tile_id, id)

func _get_point_id(x, y):
    return x * 1000 + y

func _pos_2_point_id(pos):
    return self._get_point_id(pos.x, pos.y)

func _point_id_2_pos(id):
    return self.grid[id][POSITION_KEY]

func _get_adjacent_tile_ids(tile_id):
    var ids = IntArray([])
    var field
    if self.grid.has(tile_id):
        var neighbours = self.grid[tile_id][self.NEIGHBOURS_KEY]
        for neighbour in neighbours.values():
            field = self.bag.abstract_map.get_field(neighbour)
            if field != null and !field.is_empty():
                ids.push_back(self.get_point_id(neighbour.x, neighbour.y))

    return ids

func _reset_obstacles():
    self.obstacles.clear()
    self.new_obstacles.clear()

func _reset_grid():
    self._disconnect_all()
    self._reset_obstacles()

func _validate_tile(pos): # TODO - move to abstract map or tile or smth
    if pos.x < 0 or pos.x > self.bag.abstract_map.MAX_MAP_SIZE:
        return false
    if pos.y < 0 or pos.y > self.bag.abstract_map.MAX_MAP_SIZE:
        return false
    var tile_id = self._pos_2_point_id(pos)

    if self.map_grid.has(tile_id) and self.map_grid[tile_id].passable == false:
        return false

    return true

func _prepare_neighbours(x, y):
    var neighbours = {
        "u" : Vector2(x  ,y-1),
        "r" : Vector2(x+1,y  ),
        "d" : Vector2(x  ,y+1),
        "l" : Vector2(x-1,y  ),
    }
    var output = {}

    for direction in neighbours:
        if self._validate_tile(neighbours[direction]):
            output[direction] = neighbours[direction]

    return output
