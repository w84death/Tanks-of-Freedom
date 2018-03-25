extends "res://scripts/yuri/actions/hands/base_hand.gd"

func _initialize():
    self.handled_action = preload("res://scripts/yuri/actions/types/move_action.gd")


func execute(action):
    if action.path.size() < 2:
        return

    self.bag.controllers.action_controller.set_active_field(action.entity.position_on_map)
    self.bag.controllers.action_controller.handle_action(action.path[1])
