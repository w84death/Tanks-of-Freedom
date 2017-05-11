extends "res://scripts/ai/actions/action_object.gd"

func _init(bag, unit, path):
    self.type = ACTION_SPAWN
    self.unit = unit
    self.path = path
    self.bag  = bag

func execute():
    self.bag.controllers.action_controller.set_active_field(unit.get_pos_map())
    self.bag.controllers.action_controller.spawn_unit_from_active_building()
    return true