extends "res://scripts/storyteller/triggers/abstract_trigger.gd"

func _initialize():
	self.trigger_types_used['turn_end'] = true

func is_triggered(trigger_details, story_event):
	return trigger_details['details']['turn'] == story_event['details']['turn']
