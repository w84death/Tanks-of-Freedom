extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
    var field = self.bag.abstract_map.get_field(action_details['who'])
    field.object.die_after_explosion(null)
    field.object = null
    self.bag.root.action_controller.collateral_damage(action_details['who'])
