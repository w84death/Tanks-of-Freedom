extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
    if action_details.has('speed'):
        self.bag.camera.camera_speed = action_details['speed']
    else:
        self.bag.camera.camera_speed = self.bag.camera.CAMERA_ACCELERATION
    self.bag.camera.move_to_map(action_details['where'])
