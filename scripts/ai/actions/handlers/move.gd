extends "res://scripts/ai/actions/handlers/unit_handler.gd"

func _init(bag):
    self.bag = bag

func execute(action):
    print("move")
    .execute(action)


func __on_success(action):
    action.proceed()
    self.remove_for_unit(action.unit, action)
    self.mark_unit_for_calculations(action.unit)
    if action.unit.ap == 0:
        action.score = 0

    if action.path.size() < 2:
        if action.unit.type != 0 and action.destination.group == 'waypoint':
            self.bag.waypoint_factory.mark_building_as_blocked(action.destination.point_of_interest)

        self.bag.actions_handler.remove(action)

func __on_fail(action):
    self.bag.actions_handler.remove(action)
    if self.get_actions_for_unit(action.unit).size() == 0:
        self.mark_unit_for_calculations(action.unit)
    self.reset_current_action()





