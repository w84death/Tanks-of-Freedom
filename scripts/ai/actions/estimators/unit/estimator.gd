const WAYPOINT_WEIGHT = 50
const BUILDING_WEIGHT = 50

var bag
var score

var waypoint_value = {
	0: 14,  # TYPE_BUNKER
	1: 8, # TYPE_BARRACKS
	2: 8, # TYPE_FACTORY
	3: 5, # TYPE_AIRPORT
	4: 10 # TYPE_TOWER
	}

var nearby_tiles = []

func score_attack(action):
    #init
    self.__prepare_info(action)

    if action.unit.life == 0:
        return 0

    if !action.unit.can_attack() or !self.has_ap(action):
        return 0

    var enemy = self.get_target_object(action)
    if enemy.group != 'unit' or action.unit.player == enemy.player:
        return 0

    var score = 20
    score = self.__health_level(action.unit) * 20

    if enemy.life < action.unit.attack:
        score = score + 200
    elif !enemy.can_defend():
        score = score + 50

    if enemy_buildings_in_sight(action).size():
        score = score + 50

    if own_buildings_in_sight(action).size():
        score = score + 450

    if self.bag.controllers.action_controller.turn > 8:
        score = score * 1.2

    return self.ATTACK_MOD + score

func score_move(action):
    #init
    self.__prepare_info(action)

    if !self.can_move(action) or !self.has_ap(action):
        return 0

    if self.__should_use_last_ap(action):
        return 0

    if self.__should_hold_waypoint(action):
        return 0

    var waypoint_value = self.get_waypoint_value(action)
    var score = waypoint_value * self.WAYPOINT_WEIGHT

    if waypoint_value == 0:
        score = score + 180
        score = score + self.__health_level(action.unit) * 10

    # TODO - parameters changing during game
    if self.bag.controllers.action_controller.turn < 4:
        if action.destination.group == 'waypoint' and action.unit.type != 0:
            score = score * 0.3
        score = score - (action.path.size() * 40)
    else:
        score = score - (action.path.size() * 15)

    if action.proceed:
        score = score + 50 + (action.proceed * 10)

    score = self.MOVE_MOD + score - (self.__danger(action) * 8)

    if waypoint_value > 0 && action.unit.check_hiccup(action.path[1]):
        score = score * 0.5

    return score

func score_recalc_path_move(action):
    self.score_move(action)

func __should_hold_waypoint(action):
    if action.unit.type == 0:
        return false

    var current_field = self.bag.abstract_map.get_field(action.path[0])
    if current_field.waypoint == null or current_field.waypoint.for_player == action.unit.player:
        return false

    for unit in self.own_units_in_sight(action):
        if unit.type == 0:
            return false

    return true

func __should_use_last_ap(action):
    if action.unit.ap == 1 and !action.unit.can_attack() and !self.enemies_in_sight(action).size():
        return true
    return false

func __danger(action):
    randomize()
    var danger = 0
    if randf() < 0.2:
        for unit in self.enemies_in_sight(action):
            danger = danger + self.danger_modifier[unit.type]
        for unit in self.own_units_in_sight(action):
            danger = danger - self.danger_modifier[unit.type]

    return danger

func __prepare_info(action):
   self.nearby_tiles = self.bag.positions.get_nearby_tiles(action.path[0], 4)

func __ap_level(unit):
	return 1.0 * unit.ap / unit.max_ap

func __health_level(unit):
	return 1.0 * unit.life / unit.max_life

func get_target_object(action):
    return self.bag.abstract_map.get_field(action.path[1]).object

func is_destination_building(action):
    return action.destination.group == 'building'

func is_destination_waypoint(action):
    return action.destination.group == 'waypoint'

func is_destination_unit(action):
    return action.destination.group == 'unit'

func has_ap(action):
    return action.unit.ap > 0

func can_move(action):
    var field = self.bag.abstract_map.get_field(action.path[1])
    if field.has_building() or field.has_unit():
        return false

    return true

func get_waypoint_value(action):
    var value = 0
    if action.destination.group == 'waypoint':
        if  action.destination.point_of_interest != null:
            value = self.waypoint_value[action.destination.point_of_interest.type]

        if action.destination.subtype == action.destination.TYPE_SPAWN_POINT:
            value = value + 1
    return value

func get_building_value(action):
     return self.waypoint_value[action.destination.type]

func enemies_in_sight(action):
    return self.bag.positions.get_nearby_enemies(self.nearby_tiles, action.unit.player)

func own_units_in_sight(action):
    return self.bag.positions.get_nearby_enemies(self.nearby_tiles, action.unit.player)

func enemy_buildings_in_sight(action):
    return self.bag.positions.get_nearby_enemy_buildings(self.nearby_tiles, action.unit.player) + self.bag.positions.get_nearby_empty_buldings(self.nearby_tiles)

func own_buildings_in_sight(action):
    return self.bag.positions.get_nearby_enemy_buildings(self.nearby_tiles, action.unit.player )


func buildings_in_sight(action):
    return self.bag.positions.get_nearby_buildings(self.nearby_tiles)

func target_can_be_captured(action):
    var tile = self.bag.abstract_map.get_field(action.path[1])
    if !action.unit.can_capture_building(tile.object):
        return false

    return true
