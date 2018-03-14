extends "res://scripts/ai/actions/handlers/handler.gd"

func _init(bag):
    self.bag = bag

func execute(action):
    print(' void action ')
    self.bag.actions_handler.remove(action)
    self.reset_current_action()
    return true

