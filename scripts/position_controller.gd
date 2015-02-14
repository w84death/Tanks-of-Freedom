var root_node
var buildings
var bunkers
var center

# dictionaries with encoded positions
var units_player_blue = {}
var units_player_red = {}
var buildings_player_none = {}
var buildings_player_blue = {}
var buildings_player_red = {}
var terrain_obstacles = {}

var units

const lookout_range = 3

func init_root(root):
	root_node = root

	bunkers = {0: null, 1: null}
	get_bunkers()

func refresh():
	units_player_blue.clear()
	units_player_red.clear()
	buildings_player_none.clear()
	buildings_player_blue.clear()
	buildings_player_red.clear()
	terrain_obstacles = {}

	get_units()
	get_buildings()
	get_terrain()

func get_player_units(player):
	if player == 0:
		return units_player_blue
	return units_player_red
	
func get_player_buildings(player):
	if player == 0:
		return buildings_player_blue
	return buildings_player_red

func get_player_bunker_position(player):
	return bunkers[player].get_initial_pos()

func get_terrain_obstacles():
	return terrain_obstacles

func get_bunkers():
	buildings = root_node.get_tree().get_nodes_in_group("buildings")
	for building in buildings:
		if (building.type == 0):
			bunkers[building.get_player()] = building

func get_terrain():
	var terrains = root_node.get_tree().get_nodes_in_group("terrain")
	for terrain in terrains:
		var pos = self.position_to_key(terrain.get_pos_map())
		terrain_obstacles[pos] = terrain

func get_units():
	units = root_node.get_tree().get_nodes_in_group("units")
	units_player_blue.clear()
	units_player_red.clear()

	for unit in units:
		var pos = self.position_to_key(unit.get_pos_map())
		if(unit.get_player() == 1):
			units_player_red[pos] = unit
		else:
			units_player_blue[pos] = unit

func get_nearby_tiles(position, distance=2):
	var max_distance = distance *2 -1
	var tiles = []
	for y in range(-distance, distance):
		for x in range(-distance, distance):
			# we are skipping current tile
			if (self.fabs(x) + self.fabs(y) < max_distance && x != 0 && y != 0):
				tiles.append(Vector2(position.x + x, position.y + y))

	return tiles

# for red
func get_nearby_enemies(nearby_tiles, current_player):
	var enemy_units_collection
	if current_player == 0:
		enemy_units_collection = units_player_red
	else:
		enemy_units_collection = units_player_blue
	
	var enemies = []
	for tile in nearby_tiles:
		var tile_key = self.position_to_key(tile)
		if enemy_units_collection.has(tile_key):
			enemies.append(enemy_units_collection[tile_key])

	return enemies

func get_buildings():
	buildings = root_node.get_tree().get_nodes_in_group("buildings")
	for building in buildings:
		var pos = self.position_to_key(building.get_pos_map())
		if (building.get_player() == 0):
			buildings_player_blue[pos] = building
		elif(building.get_player() == 1):
			buildings_player_red[pos] = building
		else:
			buildings_player_none[pos] = building

#for red
func get_nearby_enemy_buldings(nearby_tiles, current_player):
	var enemy_buildings_collection
	if current_player == 0:
		enemy_buildings_collection = buildings_player_red
	else:
		enemy_buildings_collection = buildings_player_blue
		
	var buildings = []
	for tile in nearby_tiles:
		var tile_key = self.position_to_key(tile)
		if enemy_buildings_collection.has(tile_key):
			buildings.append(enemy_buildings_collection[tile_key])

	return buildings

#for red
func get_nearby_empty_buldings(nearby_tiles):
	var buildings = []
	for tile in nearby_tiles:
		var tile_key = self.position_to_key(tile)
		if buildings_player_none.has(tile_key):
			buildings.append(buildings_player_none[tile_key])

	return buildings

func fabs(value):
	if value < 0:
		return -value
	else:
		return value

func position_to_key(position):
	return str(position.x)+':'+str(position.y)


