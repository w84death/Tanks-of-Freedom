extends "res://scripts/ai/actions/handlers/handler.gd"

func _init(bag):
    self.bag = bag

func execute(action):
    var active_field = self.bag.controllers.action_controller.set_active_field(action.unit.position_on_map)
    if self.bag.controllers.action_controller.spawn_unit_from_active_building():
        self.__on_success(action)
        return true
    else:
        self.__on_fail(action)

    return false

func __on_success(action):
    #removing all spawn actions
    self.remove_for_type(action.type)