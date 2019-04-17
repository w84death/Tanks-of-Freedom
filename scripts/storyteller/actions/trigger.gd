extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
	var trigger_name = action_details['name']
	var is_suspended = action_details['suspended']

	self.bag.storyteller.action_triggers.suspend(trigger_name, is_suspended)

