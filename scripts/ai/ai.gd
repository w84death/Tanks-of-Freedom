extends "res://scripts/bag_aware.gd"

var action_controller
const CLOSE_RANGE = 6
const LOOKUP_RANGE = 20
var actions
var offensive
var current_player_ap = 0
var current_player

const SPAWN_LIMIT = 20
const DEBUG = false
var own_units
var own_buildings
var enemy_bunker

var finished_loop = true
var units_done = false
var processed_units = {}
var camera_ready = false
var ap_for_turn = null
var thread

func _initialize():
    self.action_controller = self.bag.controllers.action_controller

    actions = preload('actions.gd').new()
    thread = Thread.new()
    self.offensive = preload('res://scripts/ai/offensive.gd').new(self.bag.abstract_map, actions, self.bag.a_star, self.bag.action_builder, self.bag.positions)

func gather_available_actions(player_ap):
    current_player = self.action_controller.current_player
    current_player_ap = player_ap

    if self.finished_loop:
        self.actions.clear()
        # refreshing unit and building data
        self.bag.positions.refresh_units()
        #positions.refresh_buildings()
        self.own_buildings = self.bag.positions.get_player_buildings(current_player)
        self.own_units     = self.bag.positions.get_player_units(current_player)

        self.__gather_building_data()

        self.finished_loop = false
        return true

    if not self.units_done:
        self.__gather_unit_data()
        return true

    if not self.camera_ready && self.actions:
        var best_action = self.actions.get_best_action()
        self.camera_ready = true
        if best_action != null:
            self.action_controller.move_camera_to_point(best_action.unit.position_on_map)

            return true

    self.reset_calculation_state()

    return actions.execute_best_action()

func reset_calculation_state():
    self.finished_loop = true
    self.units_done = false
    self.processed_units.clear()
    self.camera_ready = false

func get_target_buildings():
    var buildings = self.bag.positions.get_player_buildings( (self.current_player + 1 ) % 2)
    var unclaimed = self.bag.positions.get_unclaimed_buildings()
    for building_position in unclaimed:
        buildings[building_position] = unclaimed[building_position]
    return buildings

func __gather_unit_data():
    if self.own_units.size() == 0:
        self.units_done = true
        return

    var obstacle_positions = self.own_buildings.keys() + self.own_units.keys()
    self.bag.a_star.set_obstacles(obstacle_positions)

    var unit
    var position
    var destinations
    var unit_instance_id
    var push_units = []

    for unit_pos in self.own_units:
        unit = self.own_units[unit_pos]
        unit_instance_id = unit.get_instance_ID()
        if self.processed_units.has(unit_instance_id):
            continue

        self.processed_units[unit_instance_id] = true
        if unit.get_ap() > 1:

            destinations = self.__gather_destinations(unit_pos, unit.can_capture_buildings())
            if destinations.size() == 0 && current_player_ap > 5:
                push_units.append(unit)
            else:
                for destination in destinations:
                    self.__add_action(unit, destination)

    if push_units.size() > 0:
        var target_buildings = self.get_target_buildings()
        obstacle_positions = obstacle_positions + target_buildings.keys()
        self.bag.a_star.set_obstacles(obstacle_positions)

        for unit in push_units:
            self.offensive.push_front(unit, target_buildings, self.own_units)


    self.units_done = true

func __gather_destinations(position, can_capture_building):
    var destinations = Vector2Array()
    var nearby_tiles
    for lookup_range in self.bag.positions.tiles_lookup_ranges:
        nearby_tiles = self.bag.positions.get_nearby_tiles(position, lookup_range)

        if can_capture_building:
            destinations = self.bag.positions.get_nearby_enemy_buildings(nearby_tiles, self.current_player)
            if (destinations.size() > 0):
                return destinations

        destinations = self.bag.positions.get_nearby_enemies(nearby_tiles, self.current_player)
        if (destinations.size() > 0):
            return destinations

        if can_capture_building:
            destinations = self.bag.positions.get_nearby_empty_buldings(nearby_tiles)
            if (destinations.size() > 0):
                return destinations

    return destinations

func __gather_building_data():
    if self.own_units.size() >= SPAWN_LIMIT:
        return
    var building
    var enemy_units
    for pos in self.own_buildings:
        building = self.own_buildings[pos]

        if (building.type == 4): # skip tower
            continue
        var nearby_tiles = self.bag.positions.get_nearby_tiles(pos, 3)
        enemy_units = self.bag.positions.get_nearby_enemies(nearby_tiles, self.current_player)
        self.__add_building_action(building, enemy_units)


func __add_action(unit, destination):
    var path = self.bag.a_star.path_search(unit.position_on_map, destination.get_pos_map())

    var action_type = self.bag.action_builder.ACTION_MOVE
    var hiccup = false
    var path_size = path.size()

    if path_size == 0:
        return

    # jakies solidne WTF?
    if (unit.position_on_map == path[0]):
        path.remove(0)
        path_size = path_size - 1

    if path_size > 0:
        # skip if this can be capture move and building cannot be captured
        var unit_ap_cost = 0
        var tile_ap = 0
        # verify action_type
        var next_tile = self.bag.abstract_map.get_field(path[0])

        if (next_tile.object != null):
            if (next_tile.has_building()):
                if unit.can_capture_building(next_tile.object):
                    action_type = self.bag.action_builder.ACTION_CAPTURE
                else:
                    return
            elif next_tile.object.group == 'unit':
                if unit.can_attack_unit_type(next_tile.object) && unit.can_attack() && next_tile.object.player != unit.player:
                    action_type = self.bag.action_builder.ACTION_ATTACK
                else:
                    return
        else:
            var from = self.bag.abstract_map.get_field(unit.position_on_map)
            # todo - check why this still counts as action
            if not from.object:
                return

            var to = self.bag.abstract_map.get_field(path[0])
            if not self.bag.movement_controller.can_move(from, to):
                return

            action_type = self.bag.action_builder.ACTION_MOVE
            unit_ap_cost = path_size - 1
            var last_tile = self.bag.abstract_map.get_field(path[path_size - 1])
            if (last_tile.object != null):
                if (last_tile.has_building()):
                    if (unit.can_capture_building(last_tile.object)):
                        action_type = self.bag.action_builder.ACTION_MOVE_TO_CAPTURE

                elif(last_tile.object.group == 'unit'):
                    if (unit.can_attack_unit_type(last_tile.object)):
                        action_type = self.bag.action_builder.ACTION_MOVE_TO_ATTACK

            # checking for movement hiccup (only for movement)
            hiccup = unit.check_hiccup(path[0])


        var score = unit.estimate_action(action_type, path_size, unit_ap_cost, hiccup)
        var action = self.bag.action_builder.create(action_type, unit, path)
        actions.append_action(action, score)
        if DEBUG:
            print("DEBUG : ", action.get_action_name(), " unit: ", unit.get_instance_ID(), " unit_type:", unit.type," score: ", score, " ap: ", unit_ap_cost," pos: ",unit.get_pos_map()," path: ", path)

func __add_building_action(building, enemy_units_nearby):
    var action_type = self.bag.action_builder.ACTION_SPAWN
    var spawn_point = self.bag.abstract_map.get_field(building.spawn_point)
    if (spawn_point.object == null && building.get_required_ap() <= current_player_ap):
        var score = building.estimate_action(action_type, enemy_units_nearby, self.own_units, current_player_ap, SPAWN_LIMIT)
        var claim_modifier = 15 - (self.action_controller.turn - building.turn_claimed)
        if claim_modifier < 0:
            claim_modifier = 0

        if building.type == building.TYPE_BARRACKS:
            score = score + claim_modifier

        var action = self.bag.action_builder.create(action_type, building, null)
        actions.append_action(action, score)
        if DEBUG:
            print("DEBUG : ", action.get_action_name(), " score: ", score, " ap: ", building.get_required_ap())


func set_ap_for_turn(ap):
    self.ap_for_turn = ap

