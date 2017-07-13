extends "res://scripts/storyteller/actions/abstract_action.gd"


var avatar_portraits = {
    'soldier_blue' : 1
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
