extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
    self.bag.camera.move_to_map(action_details['where'])
