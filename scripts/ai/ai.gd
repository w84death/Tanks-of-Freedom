extends "res://scripts/bag_aware.gd"

var processed_units_object_ids = []
var player
var player_ap
var own_units
var ai_logger_enabled

const MIN_DESTINATION_PER_UNIT = 3
const SPAWN_LIMIT = 50

func _initialize():
    self.ai_logger_enabled = Globals.get('tof/ai_logger')
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

func __can_be_processed(unit):
    var unit_instance_id = unit.get_instance_ID()
    if self.processed_units_object_ids.has(unit_instance_id):
        return false

    self.processed_units_object_ids.append(unit_instance_id)
    return true

func __prepare_unit_actions():
    var destinations = null
    for unit in self.bag.positions.get_player_units(self.player).values():
        if self.__can_be_processed(unit) && unit.ap > 0 && unit.life > 0:
            for destination in self.__gather_destinations(unit):
                self.__add_action(unit, destination)

func __gather_destinations(unit):
    var own_buildings = self.bag.positions.get_player_buildings(self.player)
    var own_units     = self.bag.positions.get_player_units(self.player)
    var obstacle_positions = own_buildings.keys() + own_units.keys()
    self.bag.a_star.set_obstacles(obstacle_positions)

    var destinations = Vector2Array()
    var nearby_tiles
    for lookup_range in self.bag.positions.tiles_lookup_ranges:
        nearby_tiles = self.bag.positions.get_nearby_tiles(unit.position_on_map, lookup_range)

        destinations = self.bag.positions.get_nearby_enemies(nearby_tiles, self.player)

        if unit.type == 0:
            destinations = destinations + self.bag.positions.get_nearby_enemy_buildings(nearby_tiles, self.player)
            destinations = destinations + self.bag.positions.get_nearby_empty_buldings(nearby_tiles)
        else:
           for building in self.bag.positions.get_nearby_enemy_buildings(nearby_tiles, self.player):
               #destinations.append(building.get_spawn_point_pos()) # TODO - create dummy obj for spawn
               pass

        if destinations.size() > self.MIN_DESTINATION_PER_UNIT:
            return destinations

    return destinations

func __prepare_building_actions():
    if self.bag.positions.get_player_units(self.player).size() >= SPAWN_LIMIT:
        return

    for building in self.bag.positions.get_player_buildings(self.player).values():
        if (building.can_spawn_units()):
            self.__add_action(building, null)

func __add_action(unit, destination):
    self.bag.actions_handler.add_action(unit, destination)

func reset():
    self.processed_units_object_ids.clear()
    self.bag.actions_handler.reset()