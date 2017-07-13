extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
    var attacker_field = self.bag.abstract_map.get_field(action_details['who'])
    var victim_field = self.bag.abstract_map.get_field(action_details['whom'])

    victim_field.object.show_explosion()

    self.bag.root.sound_controller.play_unit_sound(attacker_field.object, 'attack')
    self.bag.root.sound_controller.play_unit_sound(victim_field.object, 'damage')
