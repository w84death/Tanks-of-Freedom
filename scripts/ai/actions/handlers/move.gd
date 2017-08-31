extends "res://scripts/ai/actions/handlers/handler.gd"

func _init(bag):
    self.bag = bag

func execute(action):
    var field = self.__get_next_tile_from_path(action.path)
        
    if field  != null:
        var active_field = self.bag.controllers.action_controller.set_active_field(action.unit.position_on_map)
        if active_field.object != null:
            var res = self.bag.controllers.action_controller.handle_action(field.position)
            if res["status"] == 1:
                self.__on_success(action)
                return true

    self.__on_fail(action)
    return false

func __on_success(action):
    action.proceed()
    self.remove_for_unit(action.unit, action)
    self.mark_unit_for_calculations(action.unit)
    if action.unit.ap == 0:
        action.score = 0

    if action.path.size() < 2:
        if action.destination.group == 'waypoint' and action.unit.type == 0:
#           if action.unit.type == 0 and self.bag.helpers.is_adjacent(action.point_of_interest.position_on_map, action.unit.position_on_map):
            if action.destination.point_of_interest.player != action.unit.player:
                self.bag.actions_handler.add_action(action.unit, action.destination.point_of_interest)
                print("added capture action ", action.destination.point_of_interest.get_building_name())

        self.bag.actions_handler.remove(action)

func __on_fail(action):
    action.fails = action.fails + 1
    action.score = action.score - 20
    action.proceed = 0
    if action.fails >= 2:
        self.bag.actions_handler.remove(action)
        if self.get_actions_for_unit(action.unit).size() == 0:
            self.mark_unit_for_calculations(action.unit)





