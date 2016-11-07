extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
    var source_field = self.bag.abstract_map.get_field(action_details['who'])
    var destination_field = self.bag.abstract_map.get_field(action_details['where'])
    source_field.object.set_pos_map(action_details['where'])
    destination_field.object = source_field.object
    source_field.object = null
