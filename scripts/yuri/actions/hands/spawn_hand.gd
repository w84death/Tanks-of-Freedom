extends "res://scripts/yuri/actions/hands/base_hand.gd"

func _initialize():
    self.handled_action = preload("res://scripts/yuri/actions/types/spawn_unit_action.gd")

func execute(action):
    self.bag.controllers.action_controller.set_active_field(action.entity.position_on_map)
    self.bag.controllers.action_controller.spawn_unit_from_active_building()
