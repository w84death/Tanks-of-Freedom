extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
	var field = self.bag.abstract_map.get_field(action_details['who'])

	if field.object == null:
		return

	field.object.die_after_explosion(null)
	self.bag.root.sound_controller.play_unit_sound(field.object, 'die')
	field.object = null
	self.bag.root.action_controller.collateral_damage(action_details['who'])

	self.bag.positions.refresh_units()
