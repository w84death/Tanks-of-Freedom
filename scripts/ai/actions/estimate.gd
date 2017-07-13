extends "res://scripts/bag_aware.gd"

func run(action):
    if action.is_unit_action() and action.path.size() == 0:
        action.path = self.bag.a_star.path_search(action.unit.position_on_map, action.destination.get_pos_map())

        if action.destination != action.point_of_interest:
            action.path.append(action.point_of_interest.position_on_map)

    action.score = 0
    self.bag.estimate_strategy.score(action)
    action.add_age()

    return action.score

