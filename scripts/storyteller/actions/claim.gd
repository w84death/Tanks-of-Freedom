extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
    var source_field = self.bag.abstract_map.get_field(action_details['what'])
    source_field.object.claim(action_details['side'], 0)
    self.bag.root.sound_controller.play('occupy_building')

    self.bag.positions.refresh_buildings()