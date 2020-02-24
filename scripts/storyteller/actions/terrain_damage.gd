extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
	var positionVAR = action_details['where']
	var field = self.bag.abstract_map.get_field(positionVAR)

	var object = field.object
	if object != null:
		self.bag.root.sound_controller.play('explosion')
		object.set_damage()

