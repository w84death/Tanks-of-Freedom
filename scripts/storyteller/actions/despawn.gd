extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
	var field = self.bag.abstract_map.get_field(action_details['who'])

	if field.object == null:
		return

	field.object.queue_free()
	field.object = null

	self.bag.positions.refresh_units()

