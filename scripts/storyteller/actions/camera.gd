extends "res://scripts/storyteller/actions/abstract_action.gd"

func perform(action_details):
	if action_details.has('speed'):
		self.bag.camera.camera_speed = action_details['speed']
	else:
		self.bag.camera.update_camera_speed_scale()
	if action_details.has('zoom'):
		self.bag.camera.set_zoom_value(action_details['zoom'])
	self.bag.camera.move_to_map(action_details['where'], true)

