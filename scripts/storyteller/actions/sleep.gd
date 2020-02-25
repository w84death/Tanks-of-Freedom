extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
	self.bag.storyteller.pause = true
	self.bag.timers.set_timeout(action_details['time'], self, 'remove_sleep')

func remove_sleep():
	self.bag.storyteller.pause = false

