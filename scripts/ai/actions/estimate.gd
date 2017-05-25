extends "res://scripts/bag_aware.gd"

func run(action):
    if action.group == 'unit':
        return self.__estimate_unit(action)
    else:
        return self.__estimate_building(action)

func __estimate_unit(action):
    if action.path.size() == 0:
        action.path = self.bag.a_star.path_search(action.unit.position_on_map, action.destination.get_pos_map())

    var distance = action.path.size()

    action.score = 0
    self.bag.estimate_strategy.score(action)
    return action.score

func __estimate_building(action):
    var score = 0
    action.type = "spawn"
    action.score = 0
    if self.bag.abstract_map.get_field(action.unit.spawn_point).object:
        return

    if !self.bag.controllers.action_controller.has_enough_ap(action.unit.get_required_ap()):
        return

    # enemies modifier
    var nearby_tiles
    for lookup_range in [1,2,3,4,5]:
        nearby_tiles = self.bag.positions.get_nearby_tiles(action.start, lookup_range)
        score = score + 5 * (self.bag.positions.get_nearby_enemies(nearby_tiles, action.unit.player).size() * (6 - lookup_range))

    # distance modifier (further from base TODO - closer to enemy?)
    var distance_from_hq = self.bag.a_star.get_distance(action.start, self.bag.positions.get_player_bunker_position(action.unit.player))
    if distance_from_hq > 10:
        score = score + distance_from_hq - 10

    score = score + 80 * self.unit_limit_mod(self.bag.positions.get_player_units(action.unit.player).size())
    action.score = score

func unit_limit_mod(x):
    if x == 0:
       return 1
    return pow(0.95, x)

