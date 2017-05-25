extends "res://scripts/ai/actions/handlers/handler.gd"

func _init(bag):
    self.bag = bag

func execute(action):
    var field = self.__get_next_tile_from_path(action.path)
    if field != null:
        var active_fied = self.bag.controllers.action_controller.set_active_field(action.unit.position_on_map)
        var res = self.bag.controllers.action_controller.handle_action(field.position)
        if res["status"] == 1:
            self.__on_success(action)
            return true

    self.__on_fail(action)
    return false

func __on_success(action):
    self.remove_for_destination(action)
    self.bag.positions.refresh_units()
    self.bag.positions.refresh_buildings()
    if action.destination.type != 4: #if gsm tower
        self.remove_for_unit(action.unit)
        self.mark_unit_for_calculations(action.unit)

