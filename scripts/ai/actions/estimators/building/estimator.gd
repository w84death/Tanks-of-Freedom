const SPAWN_MOD = 100
const MAX_UNIT_LIMIT = 35

var bag
var score = 0
var unit_type_mod = [0.5, 0.3, 0.2]

func _init(bag):
    self.bag = bag

func score(action):
    if self.bag.abstract_map.get_field(action.unit.spawn_point).object:
        return 0

    if !self.bag.controllers.action_controller.has_enough_ap(action.unit.get_required_ap()):
        return 0

    # enemies modifier
    var nearby_tiles
    var nearby_enemies
    var troops_nearby = false
    for lookup_range in [1,2,3,4,5,6]:
        nearby_tiles = self.bag.positions.get_nearby_tiles(action.start, lookup_range)
        nearby_enemies = self.bag.positions.get_nearby_enemies(nearby_tiles, action.unit.player)
        for enemy in nearby_enemies:
            if enemy.type == 0: # soldier
                if action.unit.type == 0:
                    troops_nearby = true
                    score = score * 1.3
                else:
                    score = score * 1.1
            else:
                score = score * 1.2

    if !troops_nearby and !self.__can_produce_more_unit(action.unit.player, action.unit.get_spawn_type()):
        return 0

    # distance modifier (further from base TODO - closer to enemy?)
    var distance_from_hq = self.bag.a_star.get_distance(action.start, self.bag.positions.get_player_bunker_position(action.unit.player))
    if distance_from_hq > 10:
        score = score + distance_from_hq + 10

    score = score + 80 * self.__unit_limit_mod(action.unit.player)

    return self.SPAWN_MOD + score

func __unit_limit_mod(player):
    var size = self.bag.positions.get_player_units(player).size()
    if size == 0:
       return 1
    return pow(0.93, size)

func __unit_count_by_type(player, unit_type):
    var count = 0
    for unit in self.bag.positions.get_player_units(player).values():
        if unit.type == unit_type:
            count = count + 1
    return count

func __can_produce_more_unit(player, unit_type):
    var movable_tiles_count = self.bag.a_star.passable_field_count
    var max_unit_limit = movable_tiles_count / 5
    if self.__unit_count_by_type(player, unit_type) >= self.unit_type_mod[unit_type] * max_unit_limit:
        return false
    return true



