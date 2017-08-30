extends "res://scripts/bag_aware.gd"

func run(action):
    if action.is_unit_action() and action.path.size() == 0:
        var start = action.unit.position_on_map
        var end   = action.destination.get_pos_map()
        action.path = get_simple_path(start, end)
        if action.path.size() == 0:
            action.path = self.bag.a_star.path_search(start, end)

    action.score = 0
    self.bag.estimate_strategy.score(action)
    action.add_age()

    return action.score

func get_simple_path(start, end):
    if self.bag.a_star.get_distance(start, end) == 1 && self.bag.helpers.is_adjacent(start, end):
        return [start, end]

    return []

