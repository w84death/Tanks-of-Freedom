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
    if self.bag.a_star.get_distance(start, end) == 1 && self.is_adjacent(start, end):
        return [start, end]

    return []

func is_adjacent(start, end):
    var diff_x = abs(start.x - end.x)
    var diff_y = abs(start.y - end.y)

    return (diff_x + diff_y) == 1

