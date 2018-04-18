extends "res://scripts/yuri/actions/hands/base_hand.gd"

func _initialize():
    self.handled_action = preload("res://scripts/yuri/actions/types/move_action.gd")

func execute(action):
    if action.path.size() < 2:
        return

    var field = self.bag.abstract_map.get_field(action.path[1])
    if field.object != null && field.object.player == self.bag.controllers.action_controller.current_player:
        return

    self.bag.controllers.action_controller.set_active_field(action.entity.position_on_map)
    self.bag.controllers.action_controller.handle_action(action.path[1])
