const WAYPOINT_WEIGHT = 50

var bag
var score
var waypoint_value = {0: 12, 1 : 5, 2: 7, 3: 3, 4: 4}

func __ap_level(unit):
	return 1.0 * unit.ap / unit.max_ap

func __health_level(unit):
	return 1.0 * unit.life / unit.max_life

func get_target_object(action):
    return self.bag.abstract_map.get_field(action.path[1]).object

func has_ap(action):
    return action.unit.ap > 0

func can_move(action):
    var field = self.bag.abstract_map.get_field(action.path[1])
    if field.has_building() or field.has_unit():
        return false

    return true

func get_waypoint_value(action):
    var object = self.bag.abstract_map.get_field(action.destination.position_on_map).object
    if object == null:
        return 0
    #TODO - stub for waypoint handling
    return self.waypoint_value[object.type]

func enemies_in_sight(action):
    var nearby_tiles = self.bag.positions.get_nearby_tiles(action.path[0], 4)
    return self.bag.positions.get_nearby_enemies(nearby_tiles, action.unit.player)

func enemy_buildings_in_sight(action):
    var nearby_tiles = self.bag.positions.get_nearby_tiles(action.path[0], 6)
    return self.bag.positions.get_nearby_enemy_buildings(nearby_tiles, action.unit.player) + self.bag.positions.get_nearby_empty_buldings(nearby_tiles)

func own_buildings_in_sight(action):
    var nearby_tiles = self.bag.positions.get_nearby_tiles(action.path[0], 6)
    return self.bag.positions.get_nearby_enemy_buildings(nearby_tiles, (action.unit.player + 1) % 2 )

func target_can_be_captured(action):
    var tile = self.bag.abstract_map.get_field(action.path[1])
    if !action.unit.can_capture_building(tile.object):
        return false

    return true

func __score_attack(action):
    if action.unit.life == 0:
        return 0

    if !action.unit.can_attack() or !self.has_ap(action):
        return 0

    var enemy = self.get_target_object(action)
    if enemy.group != 'unit' or action.unit.player == enemy.player:
        return 0

    # highr health is better
    var score = self.__health_level(action.unit) * 20

    # doest enemy will be killed

    if enemy.life < action.unit.attack:
        score = score + 200
    elif !enemy.can_defend():
        score = score + 50

    if enemy_buildings_in_sight(action).size():
        score = score + 50

    if own_buildings_in_sight(action).size():
        score = score + 150

    return self.ATTACK_MOD + score

func __score_move(action):
    if !self.can_move(action) or !self.has_ap(action):
        return 0

    # if enemies nearby dont use last ap (defend)
    if action.unit.ap == 1 and !action.unit.can_attack() and self.enemies_in_sight(action).size():
        return 0

    var score = self.get_waypoint_value(action) * self.WAYPOINT_WEIGHT
    # higher ap is better
    score = score + self.__health_level(action.unit) * 20

    score = score - (action.path.size() * 3)

    if action.proceed:
        score = score + 50 + (action.proceed * 10)

    self.MOVE_MOD + score

    if action.unit.check_hiccup(action.path[1]):
        score = score * 0.2

    return score

func __score_recalc_path_move(action):
    self.__score_move(action)
