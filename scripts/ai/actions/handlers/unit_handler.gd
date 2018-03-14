extends "res://scripts/ai/actions/handlers/handler.gd"

func execute(action):
    var field = self.__get_next_tile_from_path(action.path)
    if field != null:
        self.bag.controllers.action_controller.set_active_field(action.unit.position_on_map)
        var res = self.bag.controllers.action_controller.handle_action(field.position)
        if res["status"] == 1:
            self.__on_success(action)
            return true

    self.__on_fail(action)
    return false