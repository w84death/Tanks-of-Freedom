const WAYPOINT_WEIGHT = 50
const BUILDING_WEIGHT = 50

var bag
var score

var waypoint_value = {
	0: 14,  # TYPE_BUNKER
	1: 8, # TYPE_BARRACKS
	2: 8, # TYPE_FACTORY
	3: 5, # TYPE_AIRPORT
	4: 10, # TYPE_TOWER
	10: 5, # WAYPOINT TODO - check
	11: 7, # WAYPOINT
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

    return self.ATTACK_MOD + score

func score_capture(action):
    #init
    self.__prepare_info(action)

    if action.unit.life == 0 or !self.has_ap(action):
        return 0

#    var enemy = self.get_target_object(action)
#    if action.unit.player == enemy.player:
#        return 0
#
#    if !self.target_can_be_captured(action):
#        return 0
#
    var score = self.get_building_value(action) * self.BUILDING_WEIGHT
#    # lower health is better
#    score = score + (1 - self.__health_level(action.unit))
#    if self.bag.controllers.action_controller.turn < 8:
#        score = score * 1.2

    return self.CAPTURE_MOD + score

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
    if action.unit.ap == 1 and !self.enemies_in_sight(action).size():
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
    return self.bag.abstract_map.get_field(action.path[action.path.size() - 1]).object

func is_destination_building(action):
    return action.destination.group == 'building'

func is_destination_waypoint(action):
    return action.destination.group == 'waypoint'

func is_destination_unit(action):
    return action.destination.group == 'unit'

func has_ap(action):
    return action.unit.ap > 0

func can_move(action):
    var field = self.bag.abstract_map.get_field(action.path[action.path.size() - 1])
    if field.has_building() or field.has_unit():
        return false

    return true

func get_waypoint_value(action):
    var value = 0

    if action.invalid:
        return 0

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
    var tile = self.bag.abstract_map.get_field(action.path[action.path.size() - 1])
    if !action.unit.can_capture_building(tile.object):
        return false

    return true
    
    
