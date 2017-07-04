extends "res://scripts/bag_aware.gd"

var action_controller

func _initialize():
    self.action_controller = self.bag.controllers.action_controller

func check_turn_cap():
    if self.bag.root.settings['turns_cap'] > 0:
        if self.action_controller.turn >= self.bag.root.settings['turns_cap']:
            self.action_controller.end_game(-1)

func check_win_conditions(field):
    if field.object.type == 0:
        self.action_controller.end_game(self.action_controller.current_player)
    return 1



