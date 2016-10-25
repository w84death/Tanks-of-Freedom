var root_node
var bunkers
var center
var root_tree
var bag

# dictionaries with encoded positions
var units_player_blue = {}
var units_player_red = {}
var all_units = {}
var all_buildings = {}
var buildings_player_none = {}
var buildings_player_blue = {}
var buildings_player_red = {}
var terrain_obstacles = {}

var units

const lookout_range = 3

# performance hack
var precalculated_nearby_tiles = [[[null]]]
var precalculated_nearby_tiles_ranges = [[[null]]]

const MAX_PRECALCULATED_TILES_RANGE = 20
const CLOSE_RANGE = 0
const MEDIUM_RANGE = 1
const LONG_RANGE = 2
const EXTREME_RANGE = 3 # will be not used in the future
var tiles_lookup_ranges = [1,2,3,4,5,6,7,8] # todo - check this mechanism
var tiles_building_lookup_ranges = [1,2]

# not changable data
var buildings = []
var terrains = []

var pathfinding

func _init_bag(bag):
    self.bag = bag
    self.root_node = bag.root
    self.root_tree = root_node.get_tree()
    bunkers = {0: null, 1: null}
    self.prepare_nearby_tiles()
    self.prepare_nearby_tiles_ranges()

func bootstrap():
    buildings = self.root_tree.get_nodes_in_group("buildings")
    terrains = self.root_tree.get_nodes_in_group("terrain")
    get_bunkers()
    get_terrain()

    prepare_nearby_tiles()
    prepare_nearby_tiles_ranges()

func refresh():
    self.units_player_blue = {}
    self.units_player_red = {}
    self.all_units = {}
    self.all_buildings = {}
    self.buildings_player_none = {}
    self.buildings_player_blue = {}
    self.buildings_player_red = {}
    self.terrain_obstacles = {}
    self.get_bunkers()
    self.get_terrain()
    self.refresh_units()
    self.refresh_buildings()
    self.prepare_nearby_tiles()
    self.prepare_nearby_tiles_ranges()


func refresh_units():
    units_player_blue.clear()
    units_player_red.clear()
    all_units.clear()
    all_buildings.clear()

    get_units()

func refresh_buildings():
    buildings_player_none.clear()
    buildings_player_blue.clear()
    buildings_player_red.clear()
    all_buildings.clear()

    get_buildings()

func get_player_units(player):
    if player == 0:
        return units_player_blue
    return units_player_red

func get_player_buildings(player):
    if player == 0:
        return buildings_player_blue
    return buildings_player_red

func get_unclaimed_buildings():
    return self.buildings_player_none

func get_player_bunker_position(player):
    var bunker = bunkers[player]
    if bunker == null:
        return null
    return bunker.get_initial_pos()

func get_terrain_obstacles():
    return terrain_obstacles

func get_bunkers():
    for building in buildings:
        if (building.type == 0):
            bunkers[building.get_player()] = building

func get_terrain():
    for terrain in terrains:
        terrain_obstacles[terrain.position_on_map] = terrain

func get_units():
    units = self.root_tree.get_nodes_in_group("units")

    for unit in units:
        if unit.life > 0: # skip undead units (despawn bug)
            if unit.player == 1:
                units_player_red[unit.position_on_map] = unit
            else:
                units_player_blue[unit.position_on_map] = unit
            all_units[unit.position_on_map] = unit

func get_nearby_enemies(nearby_tiles, current_player):
    var enemy_units_collection
    if current_player == 0:
        enemy_units_collection = units_player_red
    else:
        enemy_units_collection = units_player_blue

    var enemies = []
    for tile in nearby_tiles:
        if enemy_units_collection.has(tile):
            enemies.append(enemy_units_collection[tile])

    return enemies

func get_buildings():
    for building in buildings:
        var pos = building.position_on_map
        var owner = building.player

        all_buildings[pos] = building

        if (owner == 0):
            buildings_player_blue[pos] = building
        elif(owner == 1):
            buildings_player_red[pos] = building
        else:
            buildings_player_none[pos] = building

func get_nearby_enemy_buildings(nearby_tiles, current_player):
    var enemy_buildings_collection
    if current_player == 0:
        enemy_buildings_collection = buildings_player_red
    else:
        enemy_buildings_collection = buildings_player_blue

    var buildings = []
    for tile in nearby_tiles:
        if enemy_buildings_collection.has(tile):
            buildings.append(enemy_buildings_collection[tile])

    return buildings

func get_nearby_empty_buldings(nearby_tiles):
    var buildings = []
    for tile in nearby_tiles:
        if buildings_player_none.has(tile):
            buildings.append(buildings_player_none[tile])

    return buildings

func prepare_nearby_tiles():
    for distance in range(1, MAX_PRECALCULATED_TILES_RANGE):

        var max_distance = distance *2 -1
        var tiles = []

        for x in range(-distance, distance + 1):
            for y in range(-distance, distance  + 1):
                # we are skipping current tile
                if (!(x == 0 && y == 0) && !(abs(x) + abs(y) > max_distance)):
                    tiles.push_back(Vector2(x, y))
        self.precalculated_nearby_tiles.insert(distance, tiles)

func prepare_nearby_tiles_ranges():
    self.precalculated_nearby_tiles_ranges.insert(0, precalculated_nearby_tiles[0])
    for i in range(1, MAX_PRECALCULATED_TILES_RANGE):
        var values = self.bag.helpers.array_diff(precalculated_nearby_tiles[i], precalculated_nearby_tiles[i - 1])
        self.precalculated_nearby_tiles_ranges.insert(i, values)


#get all tiles
func get_nearby_tiles(position, lookup_range=CLOSE_RANGE):
    var tiles = []

    for tile_modifier in self.precalculated_nearby_tiles[lookup_range]:
        tiles.push_back(Vector2(position.x + tile_modifier.x, position.y + tile_modifier.y))

    return tiles

#only subset (ranges)
func get_nearby_tiles_subset(position, lookup_range=CLOSE_RANGE):
    var tiles = []
    if lookup_range == 0:
        return tiles

    for tile_modifier in self.precalculated_nearby_tiles_ranges[lookup_range]:
        tiles.push_back(Vector2(position.x + tile_modifier.x, position.y + tile_modifier.y))

    return tiles
