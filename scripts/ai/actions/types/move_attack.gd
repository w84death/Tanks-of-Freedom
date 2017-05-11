extends "res://scripts/ai/actions/action_object.gd"

func _init(bag, unit, path):
    self.type = ACTION_MOVE_TO_ATTACK
    self.unit = unit
    self.path = path
    self.bag  = bag


func execute():
    var field = self.__get_next_tile_from_action()
    if field != null:
        self.bag.controllers.action_controller.set_active_field(unit.position_on_map)
        if self.bag.controllers.action_controller.handle_action(field.position) == 1:
            return true

    return false