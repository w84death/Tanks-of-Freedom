extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
    var position = action_details['where']
    var field = self.bag.abstract_map.get_field(position)

    var object = field.object
    if object != null:
        self.bag.root.sound_controller.play('explosion')
        object.set_damage()
