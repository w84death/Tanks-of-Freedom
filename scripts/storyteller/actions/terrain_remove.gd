extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
	var positionVAR = action_details['where']
	var boom = action_details['explosion']
	var field = self.bag.abstract_map.get_field(positionVAR)

	var object = field.object

	field.object = null
	if object != null:
		if boom:
			object.show_explosion()
			self.bag.root.sound_controller.play('explosion')
			self.bag.timers.set_timeout(0.5, self, 'remove_object', [object])
		else:
			self.remove_object([object])



func remove_object(object):
	object[0].queue_free()
