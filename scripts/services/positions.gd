extends "res://scripts/bag_aware.gd"

var root_node
var bunkers
var center
var root_tree

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
var waypoints = {}

const lookout_range = 3
var precalculated_nearby_tiles = [[[null]]]
var precalculated_nearby_tiles_ranges = [[[null]]]

const MAX_PRECALCULATED_TILES_RANGE = 31
const CLOSE_RANGE = 0
const MEDIUM_RANGE = 1
const LONG_RANGE = 2
const EXTREME_RANGE = 3 # will be not used in the future
var TILES_LOOKUP_RANGES = IntArray(range(1, 31))

# not changable data
var buildings = []
var terrains = []

func _initialize():
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
    buildings = self.root_tree.get_nodes_in_group("buildings")
    terrains = self.root_tree.get_nodes_in_group("terrain")
    self.get_bunkers()
    self.get_terrain()
    self.refresh_units()
    self.refresh_buildings()
    self.prepare_nearby_tiles()
    self.prepare_nearby_tiles_ranges()

func refresh_units():
    self.units_player_blue.clear()
    self.units_player_red.clear()
    self.all_units.clear()
    self.all_buildings.clear()

    self.get_units()

func refresh_buildings():
    self.buildings_player_none.clear()
    self.buildings_player_blue.clear()
    self.buildings_player_red.clear()
    self.all_buildings.clear()
    self.waypoints.clear()

    self.get_buildings()
    self.get_waypoints()

func get_player_units(player):
    if player == 0:
        return units_player_blue
    return units_player_red

func get_enemy_units(player):
    return self.get_player_units(1 - player)

func get_player_buildings(player):
    if player == 0:
        return buildings_player_blue
    return buildings_player_red

func get_enemy_buildings(player):
    return self.get_player_buildings(1 - player)

func get_unclaimed_buildings():
    return self.buildings_player_none

func get_not_owned_buildings(player):
    var enemy_buildings = self.get_enemy_buildings(player)
    var combined_buildings = {}

    for key in enemy_buildings:
        combined_buildings[key] = enemy_buildings[key]

    for key in self.buildings_player_none:
        combined_buildings[key] = self.buildings_player_none[key]

    return combined_buildings

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
    buildings = self.root_tree.get_nodes_in_group("buildings")
    for building in buildings:
        var wr = weakref(building)

        if !wr.get_ref():
            continue
        else:
            building = wr.get_ref()

        var pos = building.position_on_map
        var owner = building.player

        all_buildings[pos] = building

        if (owner == 0):
            buildings_player_blue[pos] = building
        elif(owner == 1):
            buildings_player_red[pos] = building
        else:
            buildings_player_none[pos] = building

func get_nearby_buildings(nearby_tiles):
    var buildings = []
    for tile in nearby_tiles:
        if self.all_buildings.has(tile):
            buildings.append(all_buildings[tile])

    return buildings


func get_nearby_own_buildings(nearby_tiles, current_player):
    var buildings_collection
    if current_player == 1:
        buildings_collection = buildings_player_red
    else:
        buildings_collection = buildings_player_blue

    var buildings = []
    for tile in nearby_tiles:
        if buildings_collection.has(tile):
            buildings.append(buildings_collection[tile])

    return buildings

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




func get_waypoints():
    for waypoint in self.root_tree.get_nodes_in_group("waypoint"):
        self.waypoints[waypoint.position_on_map] = waypoint

func get_nearby_waypoints(nearby_tiles, current_player):
    var waypoint_collection = []
    var waypoint = null
    for tile in nearby_tiles:
        if self.waypoints.has(tile):
            waypoint = self.waypoints[tile]
            if waypoint.is_active and waypoint.applicable_for_player(current_player):
                waypoint_collection.append(waypoint)

    return waypoint_collection

func get_nearby_empty_buldings(nearby_tiles):
    var buildings = []
    for tile in nearby_tiles:
        if buildings_player_none.has(tile):
            buildings.append(buildings_player_none[tile])

    return buildings

func prepare_nearby_tiles():
    for distance in range(1, MAX_PRECALCULATED_TILES_RANGE):
        var tiles = []

        for x in range(-distance, distance + 1):
            for y in range(-distance, distance  + 1):
                # we are skipping current tile
                if (!(x == 0 && y == 0) && !(abs(x) + abs(y) > distance)):
                    tiles.push_back(Vector2(x, y))
        self.precalculated_nearby_tiles.insert(distance, tiles)

func prepare_nearby_tiles_ranges():
    self.precalculated_nearby_tiles_ranges.insert(0, precalculated_nearby_tiles[0])
    for i in range(1, MAX_PRECALCULATED_TILES_RANGE):
        var values = self.bag.helpers.array_diff(precalculated_nearby_tiles[i], precalculated_nearby_tiles[i - 1])
        self.precalculated_nearby_tiles_ranges.insert(i, values)


#get all tiles
func get_nearby_tiles(position, lookup_range=CLOSE_RANGE):
    var tiles = Vector2Array([])

    for tile_modifier in self.precalculated_nearby_tiles[lookup_range]:
        tiles.push_back(Vector2(position.x + tile_modifier.x, position.y + tile_modifier.y))

    return tiles

#only subset (ranges)
func get_nearby_tiles_subset(position, lookup_range=CLOSE_RANGE):
    var tiles = Vector2Array([])
    if lookup_range == 0:
        return tiles

    for tile_modifier in self.precalculated_nearby_tiles_ranges[lookup_range]:
        tiles.push_back(Vector2(position.x + tile_modifier.x, position.y + tile_modifier.y))

    return tiles
