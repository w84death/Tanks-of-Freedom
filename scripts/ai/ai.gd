extends "res://scripts/bag_aware.gd"

var processed_units_object_ids = []
var player
var player_ap
var own_units
var ai_logger_enabled

const MIN_DESTINATION_PER_UNIT = 5
const SPAWN_LIMIT = 25

func _initialize():
    self.ai_logger_enabled = Globals.get('tof/ai_logger')
    print('logger', self.ai_logger_enabled)
    pass

func start_do_ai(current_player, player_ap):
     var res = self.__do_ai(current_player, player_ap)
     if res == false and self.ai_logger_enabled:
        self.bag.logger.store('----------------------------- NEW TURN player %d, ap %d -------------------------- ' % [current_player, player_ap])
     return res

func __do_ai(current_player, player_ap):
    if self.ai_logger_enabled:
        self.bag.logger.store('--- do ai --- player %d, ap %d' % [current_player, player_ap])

    self.player = current_player
    self.player_ap = player_ap

    self.__prepare_unit_actions()
    self.__prepare_building_actions()

    var best_action = self.bag.actions_handler.get_best_action(self.player)
    if best_action == null:
        return false
    else:
        var result = self.bag.actions_handler.execute_best_action(best_action)
        return self.check_continue_turn(result)

func check_continue_turn(res):
    randomize()
    if self.player_ap == 0:
        return false
    if self.player_ap < 10 and (randi() % int(self.player_ap)) == 0:
        return false

    return true

func __should_prepare_actions(unit):
    var unit_instance_id = unit.get_instance_ID()
    if self.processed_units_object_ids.has(unit_instance_id):
        return false

    self.processed_units_object_ids.append(unit_instance_id)
    return true

func __prepare_unit_actions():
    var destinations = null

    # initialize
    var own_units = self.bag.positions.get_player_units(self.player)
    self.bag.a_star.set_obstacles(own_units.keys())

    for unit in own_units.values():
        if unit.ap > 0 && unit.life > 0:
            if self.__should_prepare_actions(unit):
                for destination in self.__gather_destinations(unit):
                    self.__add_action(unit, destination)
            else:
                for destination in self.__gather_nearest_enemy(unit):
                    self.__add_flash_action(unit, destination)

func __gather_nearest_enemy(unit):
    var destinations = Vector2Array()
    var nearby_tiles
    for lookup_range in range(1, unit.ap):
        nearby_tiles = self.bag.positions.get_nearby_tiles(unit.position_on_map, lookup_range)

        destinations = self.bag.positions.get_nearby_enemies(nearby_tiles, self.player)

        if destinations.size() >= 1:
            return destinations

    return destinations

func __gather_destinations(unit):
    var destinations = Vector2Array()
    var nearby_tiles
    var adjacement_tiles

    for lookup_range in self.bag.positions.TILES_LOOKUP_RANGES:
        nearby_tiles = self.bag.positions.get_nearby_tiles(unit.position_on_map, lookup_range)

        destinations = self.bag.positions.get_nearby_enemies(nearby_tiles, self.player)
        destinations = destinations + self.bag.positions.get_nearby_waypoints(nearby_tiles, self.player)

        #adding capture
        if unit.type == 0:
            adjacement_tiles = self.bag.positions.get_nearby_tiles(unit.position_on_map, 1)
            destinations = destinations + self.bag.positions.get_nearby_enemy_buildings(adjacement_tiles, self.player)
            destinations = destinations + self.bag.positions.get_nearby_empty_buldings(adjacement_tiles)

        if destinations.size() > self.MIN_DESTINATION_PER_UNIT:
            return destinations

    return destinations

func __prepare_building_actions():
    if self.bag.positions.get_player_units(self.player).size() >= self.get_spawn_limit():
        return

    for building in self.bag.positions.get_player_buildings(self.player).values():
        if (building.can_spawn_units()):
            self.__add_action(building, null)

func __add_action(unit, destination):
    self.bag.actions_handler.add_action(unit, destination)

func __add_flash_action(unit, destination):
    self.bag.actions_handler.add_action(unit, destination, self.bag.actions_handler.action.FLASH_TTL)

func reset():
    self.processed_units_object_ids.clear()
    self.bag.actions_handler.reset()

func get_spawn_limit():
    return min(self.bag.a_star.passable_field_count / 7, self.SPAWN_LIMIT)