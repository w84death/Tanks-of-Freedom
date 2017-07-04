const SPAWN_MOD = 100
var bag
var score = 0

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
    for lookup_range in [1,2,3,4,5,6]:
        nearby_tiles = self.bag.positions.get_nearby_tiles(action.start, lookup_range)
        nearby_enemies = self.bag.positions.get_nearby_enemies(nearby_tiles, action.unit.player)
        for enemy in nearby_enemies:
            if enemy.type == 0: # soldier
                if action.unit.type == 0:
                    score = score + 25
                else:
                    score = score + 10
            else:
                score = score + 5

    # distance modifier (further from base TODO - closer to enemy?)
    var distance_from_hq = self.bag.a_star.get_distance(action.start, self.bag.positions.get_player_bunker_position(action.unit.player))
    if distance_from_hq > 10:
        score = score + distance_from_hq - 10

    score = score + 80 * self.unit_limit_mod(self.bag.positions.get_player_units(action.unit.player).size())

    return self.SPAWN_MOD + score

func unit_limit_mod(x):
    if x == 0:
       return 1
    return pow(0.95, x)