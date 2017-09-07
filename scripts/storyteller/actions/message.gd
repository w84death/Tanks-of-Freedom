extends "res://scripts/storyteller/actions/abstract_action.gd"


var avatar_portraits = {
    'soldier_blue' : 0,
    'soldier_red' : 1,
    'officer_blue' : 2,
    'officer_red' : 3,
    'tank_blue' : 4,
    'tank_red' : 5,
    'heli_blue' : 6,
    'heli_red' : 7,
    'civilian' : 8
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
