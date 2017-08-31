extends "res://scripts/storyteller/actions/abstract_action.gd"


var avatar_portraits = {
    'soldier_blue' : 1,
    'soldier_red' : 2,
    'officer_blue' : 3,
    'officer_red' : 4,
    'tank_blue' : 5,
    'tank_red' : 6,
    'heli_blue' : 7,
    'heli_red' : 8,
    'civilian' : 9
}


func perform(action_details):
    var message = tr(action_details['text'])
    var avatar_frame = self.avatar_portraits[action_details['portrait']]
    var name = tr(action_details['name'])
    var left_side = true
    if action_details['side'] == 'right':
        left_side = false

    self.bag.storyteller.pause = true

    self.bag.root.hud_controller.show_story_message(left_side, message, avatar_frame, name, self, 'unpause')
    self.bag.root.sound_controller.play('menu')


func unpause():
    self.bag.storyteller.pause = false
