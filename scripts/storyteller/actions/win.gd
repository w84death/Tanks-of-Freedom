extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
	self.bag.root.action_controller.end_game(action_details['player'])
