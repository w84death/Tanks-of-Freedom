extends "res://scripts/ai/actions/handlers/handler.gd"

func _init(bag):
    self.bag = bag

func execute(action):
    print(' void action ')
    self.bag.actions_handler.remove(action)
    if self.get_actions_for_unit(action.unit).size() == 0:
        self.mark_unit_for_calculations(action.unit)
    self.reset_current_action()
    return true

